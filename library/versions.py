#!/usr/bin/python -tt
#-- NOTE: Tabs and spaces do NOT mix!! '-tt' will flag violations as an error.
#===============================================================================
"""
    :program:`versions.py`
    ============================================================

    In addition to the options listed in help output, :program:`versions.py` includes
    the following 'hidden' optoins:

    .. option:: --help-rest

        Output usage information in Sphinx/reST-style markup.

    .. option:: --debug

        Output debug-level information.

    .. option:: --debug-file <FILE>

        Save debug-level information to specified file.

        .. note:: This output is more detailed, but less readable, than simple --debug

    :synopsis: Ansible module to collect program versions as facts.

    :copyright: 2017 awmyhr
    :license: Apache-2.0

    .. codeauthor:: awmyhr <awmyhr@gmail.com>
"""
#===============================================================================
#-- Standard Imports
#-- NOTE: We use optparse for compatibility with python < 2.7 as (the superior)
#--       argparse wasn't standard until 2.7 (2.7 deprecates optparse)
#--       As of 20161212 the template is coded for optparse only
import logging      #: Python's standard logging facilities
import optparse     #: Argument parsing
import os           #: Misc. OS interfaces
import re           #: Regular Expressions
import subprocess   #: Call external programs and capture output
import sys          #: System-specific parameters & functions
from collections import defaultdict #: easily build an empty dictionary
# import traceback    #: Print/retrieve a stack traceback
#===============================================================================
#-- Third Party Imports
from ansible.module_utils.basic import AnsibleModule
#===============================================================================
#-- Require a minimum Python version
if sys.version_info <= (2, 6):
    sys.exit("Minimum Python version: 2.6")
#-- NOTE: default Python versions:
#--       RHEL4    2.3.4
#--       RHEL5    2.4.3
#--       RHEL6.0  2.6.5
#--       RHEL6.1+ 2.6.6
#--       REHL7    2.7.5
#-- Recent Fedora versions (24/25) stay current on 2.7 (2.7.12 as of 20161212)
#===============================================================================
#===============================================================================
#-- Application Library Imports
#===============================================================================
#-- Variables which are meta for the script should be dunders (__varname__)
#-- TODO: Update meta vars
__version__ = '1.0.3' #: current version
__revised__ = '2017-07-10' #: date of most recent revision
__contact__ = 'awmyhr <awmyhr@gmail.com>' #: primary contact for support/?'s

#-- The following few variables should be relatively static over life of script
__author__ = ['awmyhr <awmyhr@gmail.com>'] #: coder(s) of script
__created__ = '2017-07-07'               #: date script originlly created
__copyright__ = '2017 awmyhr' #: Copyright short name
__license__ = 'Apache-2.0'
__cononical_name__ = 'versions.py' #: static name, *NOT* os.path.basename(sys.argv[0])
__project_name__ = 'DotFiles from *NIXLand'  #: name of overall project, if needed
__project_home__ = 'https://github.com/awmyhr/dotfiles-public'  #: where to find source/docs
__template_version__ = '1.6.2'              #: version of template file used
__docformat__ = 'reStructuredText en'       #: attempted style for documentation
__basename__ = os.path.basename(sys.argv[0]) #: name script run as
__synopsis__ = 'Ansible module to collect program versions as facts.'
__description__ = """An Ansible module designed to go in a playbook library
directory. Primary purpose is to collect versions numbers of various programs
of interest and return them as facts.
"""

EXIT_STATUS = None


#===============================================================================
class _ModOptionParser(optparse.OptionParser):
    """By default format_epilog() strips newlines, we don't want that, os override."""

    def format_epilog(self, formatter):
        """We'll preformat the epilog in the decleration, just pass it through"""
        return self.epilog


#===============================================================================
class _ReSTHelpFormatter(optparse.HelpFormatter):
    """Format help for Sphinx/ReST output.

    All over-ridden methods started life as copy'n'paste from original's source
    code.
    """

    def __init__(self, indent_increment=0, max_help_position=4, width=80, short_first=0):
        optparse.HelpFormatter.__init__(self, indent_increment,
                                        max_help_position, width, short_first
                                       )

    def format_usage(self, usage):
        retval = ["%s\n" % ("=-"[self.level] * len(__cononical_name__))]
        retval.append("%s\n" % (__cononical_name__))
        retval.append("%s\n\n" % ("=-"[self.level] * len(__cononical_name__)))
        retval.append("%s" % self.format_heading('Synopsis'))
        retval.append("**%s** %s\n\n" % (__cononical_name__, usage))
        return ''.join(retval)

    def format_heading(self, heading):
        return "%s\n%s\n\n" % (heading, "--"[self.level] * len(heading))

    def format_description(self, description):
        if description:
            retval = ["%s" % self.format_heading('Description')]
            retval.append("%s\n" % self._format_text(description))
            return ''.join(retval)
        else:
            return ""

    def format_option(self, option):
        opts = self.option_strings[option]
        retval = ['.. option:: %s\n\n' % opts]
        if option.help:
            # help_text = self.expand_default(option)
            # help_lines = textwrap.wrap(help_text, self.help_width)
            retval.append("%4s%s\n\n" % ("", self.expand_default(option)))
            # retval.extend(["%4s%s\n" % ("", line)
            #                for line in help_lines[1:]])
        elif opts[-1] != "\n":
            retval.append("\n")
        return "".join(retval)

    def format_option_strings(self, option):
        """Return a comma-separated list of option strings & metavariables."""
        if option.takes_value():
            metavar = option.metavar or option.dest.upper()
            short_opts = ["%s <%s>" % (sopt, metavar)
                          for sopt in option._short_opts] #: pylint: disable=protected-access
                                                          #: We're over-riding the default
                                                          #:    method, keeping most the code.
                                                          #:    Not sure how else we'd do this.
            long_opts = ["%s=<%s>" % (lopt, metavar)
                         for lopt in option._long_opts]   #: pylint: disable=protected-access
        else:
            short_opts = option._short_opts               #: pylint: disable=protected-access
            long_opts = option._long_opts                 #: pylint: disable=protected-access

        if self.short_first:
            opts = short_opts + long_opts
        else:
            opts = long_opts + short_opts

        return ", ".join(opts)


#===============================================================================
def _version():
    """Build formatted version output

    Returns:
        The version string.

    Note:
        GNU guidelines dictate adding copyright/license info (see
        commented code)

    Warning:
        HOWEVER, this may not always be desierable.
        If not, REMOVE these lines -- do NOT leave them commented!
    """
    #-- NOTE: This entire function only exists to allow for outputting license
    #--       info per GNU guidelines. If not doing that, just remove it.
    #-- TODO: Like the OptionParser.epilog method, version strips newlines.
    #--        However, there is no format_version to override. If license
    #--        info is going to be output, this'll have to be fixed. It may
    #--        be possible to override print_version()
    # text = '%s (%s) %s' % (__cononical_name__, __project_name__, __version__)
    #-- NOTE: If license text is not desired, it is probably better to move
    #--       the string to the PARSER declaration and remove this function
    #-- TODO: UPDATE license - a boilerplate notice should go here as well
    # text += ('Copyright 2017 awmyhr\n'
    #          'License Apache-2.0\n'
    #         )


#===============================================================================
def _debug_info():
    """ Provides meta info for debug-level output """
    import platform #: Easily get platforms identifying info
    logger.debug('Cononical: %s', __cononical_name__)
    logger.debug('Abs Path:  %s', os.path.abspath(sys.argv[0]))
    logger.debug('Full Args: %s', ' '.join(sys.argv[:]))
    logger.debug('Python:    %s (%s)', sys.executable, platform.python_version())
    logger.debug('Version:   %s', __version__)
    logger.debug('Created:   %s', __created__)
    logger.debug('Revised:   %s', __revised__)
    logger.debug('Coder(s):  %s', __author__)
    logger.debug('Contact:   %s', __contact__)
    logger.debug('Project:   %s', __project_name__)
    logger.debug('Project Home: %s', __project_home__)
    logger.debug('Template Version: %s', __template_version__)
    logger.debug('System:    %s',
                 platform.system_alias(platform.system(),
                                       platform.release(),
                                       platform.version()
                                      )
                )
    if platform.system() in 'Linux':
        logger.debug('Distro:    %s', platform.linux_distribution())
    logger.debug('Hostname:  %s', platform.node())
    logger.debug('[res]uid:  %s', os.getresuid())
    logger.debug('PID/PPID:  %s/%s', os.getpid(), os.getppid())


#===============================================================================
def which(program):
    """Test if a program exists in $PATH.

    Args:
        program (str): Name of program to find.

    Returns:
        String to use for program execution.

    Note:
        Originally found this here:
        http://stackoverflow.com/questions/377017/test-if-executable-exists-in-python
    """
    logger.debug('Looking for command: %s', program)
    def _is_exe(fpath):
        """ Private test for executeable """
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(program) #: pylint: disable=unused-variable
                                          #: We are totally throwing fname away
    if fpath:
        if _is_exe(program):
            logger.debug('Found %s here.', program)
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            exe_file = os.path.join(path, program)
            if _is_exe(exe_file):
                logger.debug('Found %s here: %s', program, exe_file)
                return exe_file

    logger.debug('Could not find %s.', program)
    return None


#===============================================================================
def main():
    """ This is where the action takes place """
    logger.debug('Starting main()')
    tree = lambda: defaultdict(tree)
    module = AnsibleModule(
        argument_spec=dict(
            enabled=dict(default=True, type='bool'),
            raw=dict(default=False, type='bool')
        )
    )
    raw = module.params['raw']
    #-- This assumes the actual version number is the first space followed by
    ##  a digit. This is horrible I know, but so far it works...
    pattern = re.compile(r"(?P<vers> \d[\S]*)")

    paths = tree()
    if os.path.exists('/bin'):
        paths['os'] = '/bin'
    if os.path.exists('/usr/bin'):
        paths['usr'] = '/usr/bin'
    if os.path.exists('/usr/local/bin'):
        paths['local'] = '/usr/local/bin'
    if os.path.exists('/sbin'):
        paths['os.sys'] = '/sbin'
    if os.path.exists('/usr/sbin'):
        paths['usr.sys'] = '/usr/sbin'
    if os.path.exists('/usr/local/sbin'):
        paths['local.sys'] = '/usr/local/sbin'

    progs = tree()
    progs['bash']['args'] = '--version'
    progs['csh']['args'] = '--version'
    progs['fish']['args'] = '--version'
    progs['git']['args'] = '--version'
    progs['java']['args'] = '-version'
    progs['m-test']['args'] = '--version'
    progs['openssl']['args'] = 'version'
    progs['perl']['args'] = '-V:version'
    progs['python']['args'] = '--version'
    progs['python2']['args'] = '--version'
    progs['python3']['args'] = '--version'
    progs['ruby']['args'] = '--version'
    progs['screen']['args'] = '--version'
    progs['ssh']['args'] = '-V'
    progs['sudo']['args'] = '-V'
    progs['tcsh']['args'] = '--version'
    progs['t-test']['args'] = '--version'
    progs['tmux']['args'] = '-V'
    progs['vi']['args'] = '--version'
    progs['vim']['args'] = '--version'
    progs['yash']['args'] = '--version'
    progs['zsh']['args'] = '--version'

    facts = tree()
    for prog in progs:
        pwhich = which(prog)
        if pwhich is not None:
            facts['versions'][prog]['which'] = pwhich

        for path in paths:
            command = os.path.join(paths[path], prog)
            if os.path.isfile(command) and os.access(command, os.X_OK):
                try:
                    if sys.version_info <= (2, 6, 999):
                        proc = subprocess.Popen(
                            [command, progs[prog]['args']],
                            stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT
                        )
                        output, _ = proc.communicate()
                    else:
                        output = subprocess.check_output(
                            [command, progs[prog]['args']],
                            stderr=subprocess.STDOUT
                        )
                except subprocess.CalledProcessError as cmderr:
                    output = cmderr.output
                except Exception:
                    sys.exc_clear()

                if raw:
                    facts['raw_versions'][prog][path] = output

                # output = output.lower()
                # output = output.splitlines()[0]
                output = output.replace('"', ' ')
                output = output.replace("'", ' ')
                ver_string = pattern.search(output)
                facts['versions'][prog][path] = ver_string.group('vers').lstrip()

    module.exit_json(changed=False, ansible_facts=facts)

#===============================================================================
if __name__ == '__main__':
    #-- Parse Options (rely on OptionsParser's exception handling)
    PARSER = _ModOptionParser(
        version='%s (%s) %s' % (__cononical_name__, __project_name__, __version__),
        usage='%s [options]' % (__basename__),
        description=__synopsis__,
        epilog=('\n%s\n\n'
                'Created: %s  Contact: %s\n'
                'Revised: %s  Version: %s\n'
                '%s, part of %s. Project home: %s\n'
               ) % (__description__,
                    __created__, __contact__,
                    __revised__, __version__,
                    __cononical_name__, __project_name__, __project_home__
                   )
    )
    #-- 'Hidden' optoins
    PARSER.add_option('--help-rest', dest='helprest', action='store_true',
                      help=optparse.SUPPRESS_HELP, default=False
                     )
    PARSER.add_option('--debug', dest='debug', action='store_true',
                      help=optparse.SUPPRESS_HELP, default=False
                     )
    PARSER.add_option('--debug-file', dest='debugfile', type='string',
                      help=optparse.SUPPRESS_HELP
                     )
    (OPTIONS, ARGS) = PARSER.parse_args()
    if OPTIONS.helprest:
        PARSER.formatter = _ReSTHelpFormatter()
        PARSER.usage = '[*options*]'            #: pylint: disable=attribute-defined-outside-init
                                                #: Not yet sure of a better way to do this...
        PARSER.description = __description__    #: pylint: disable=attribute-defined-outside-init
        PARSER.epilog = ('\nAuthor\n------\n\n'
                         '%s\n'
                        ) % ('; '.join(__author__))
        PARSER.print_help()
        sys.exit(os.EX_OK)

    #-- Setup output(s)
    if OPTIONS.debug:
        LEVEL = logging.DEBUG
        FORMATTER = logging.Formatter('%(asctime)s %(levelname)-8s %(message)s',
                                      '%Y%m%d-%H%M'
                                     )
    else:
        LEVEL = logging.INFO
        FORMATTER = logging.Formatter('%(message)s')
    logger = logging.getLogger(__name__) #: pylint: disable=invalid-name
                                         #: lower-case is better here
    logger.setLevel(LEVEL)

    #-- Console output
    CONSOLE = logging.StreamHandler()
    CONSOLE.setLevel(LEVEL)
    CONSOLE.setFormatter(FORMATTER)
    logger.addHandler(CONSOLE)

    #-- File output
    if OPTIONS.debug and OPTIONS.debugfile:
        #: NOTE: In Python >= 2.6 normally I give FileHandler 'delay="true"'
        LOGFILE = logging.FileHandler(OPTIONS.debugfile)
        LOGFILE.setLevel(LEVEL)
        FORMATTER = logging.Formatter(
            '%(asctime)s.%(msecs)d:%(levelno)s:%(name)s.%(funcName)s:%(lineno)d:%(message)s',
            '%Y%m%d-%H%M'
            )
        LOGFILE.setFormatter(FORMATTER)
        logger.addHandler(LOGFILE)

    if OPTIONS.debug:
        _debug_info()
        print '\n----- start -----\n'

    #-- Do The Stuff
    try:
        main()
    except KeyboardInterrupt: # Catches Ctrl-C
        logger.debug('Caught Ctrl-C')
        EXIT_STATUS = 130
    except SystemExit: # Catches sys.exit()
        logger.debug('Caught SystemExit')
        raise
    #-- NOTE: "except Exception as variable:" syntax was added in 2.6
    except IOError as error:
        logger.debug('Caught IOError')
        if error.errno == 2:                #: No such file/directory
            logger.critical('%s: [IOError] %s: %s', __basename__,
                            error.strerror, error.filename
                           )
            EXIT_STATUS = os.EX_UNAVAILABLE
        elif error.errno == 13:                #: Permission Denied
            logger.critical('%s: [IOError] %s: %s', __basename__,
                            error.strerror, error.filename
                           )
            EXIT_STATUS = os.EX_NOPERM
        else:
            logger.critical('%s: [IOError] %s', __basename__, error.strerror)
            EXIT_STATUS = error.errno
    except OSError as error:
        logger.debug('Caught OSError')
        if error.errno == 2:                #: No such file/directory
            logger.critical('%s: [OSError] %s: %s', __basename__,
                            error.strerror, error.filename
                           )
            EXIT_STATUS = os.EX_UNAVAILABLE
        else:
            logger.critical('%s: [OSError] %s', __basename__, error.strerror)
            EXIT_STATUS = error.errno
    # except:       #: This is _not_ working, see hack below
    #     EXIT_STATUS = 1
    #     # print "Unexpected error:", sys.exc_info()[0]
    #     raise
    else:
        logger.debug('main() exited cleanly.')
        EXIT_STATUS = os.EX_OK
    #-- NOTE: "try..except..finally" does not work pre 2.5
    finally:
        logger.debug('Mandatory clean-up.')
        if EXIT_STATUS is None:
            logger.debug('EXIT_STATUS is still None.')
            EXIT_STATUS = 1
            raise #: pylint: disable=misplaced-bare-raise
                  #: Ignoring this here until I find a Better Way(TM)
        if OPTIONS.debug:
            print '\n------ end ------\n'
        sys.exit(EXIT_STATUS)
    #-- NOTE: more exit codes here:
    #--   https://docs.python.org/2/library/os.html#process-management