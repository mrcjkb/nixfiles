import os
from ranger.core.loader import CommandLoader
from ranger.api.commands import Command
from ranger.container.directory import Directory

def get_java_package_name(directory: Directory) -> str:
    path = directory.path or ""
    package = path.replace(os.path.sep, ".")
    sub = package.split("main.java.", 1)
    if len(sub) > 1:
        return sub[1]
    sub = package.split("test.java.", 1)
    if len(sub) > 1:
        return sub[1]
    sub = package.split("src.java.", 1)
    if len(sub) > 1:
        return sub[1]
    sub = package.split(".java.", 1)
    if len(sub) > 1:
        return sub[1]
    return "unknown"

class CreateJavaFileCommand(Command):
    def create_java_file(self, file_name: str, java_file_definition: str = ""):
        cwd = self.fm.thisdir
        package_name = get_java_package_name(cwd);
        file_path = os.path.join(cwd.path, file_name + ".java")
        package_line = "package " + package_name + ";\n\n"
        with open(file_path,"w") as file:
            file.write(package_line + java_file_definition)

class NewJavaFile(CreateJavaFileCommand):
    def execute(self):
        if not self.arg(1):
            return
        file_name = self.arg(1)
        self.create_java_file(file_name)

class NewJavaInterface(CreateJavaFileCommand):
    def execute(self):
        if not self.arg(1):
            return
        interface_name = self.arg(1)
        interface_definition = "public interface " + interface_name + " {\n}"
        self.create_java_file(interface_name, interface_definition)

class NewJavaRecord(CreateJavaFileCommand):
    def execute(self):
        if not self.arg(1):
            return
        record_name = self.arg(1)
        record_definition = "public record " + record_name + "() {\n}"
        self.create_java_file(record_name, record_definition)

class NewJavaFunctionalInterface(CreateJavaFileCommand):
    def execute(self):
        if not self.arg(1):
            return
        interface_name = self.arg(1)
        interface_definition = "@FunctionalInterface\npublic interface " + interface_name + " {\n}"
        self.create_java_file(interface_name, interface_definition)
            
class NewJavaClass(CreateJavaFileCommand):
    def execute(self):
        if not self.arg(1):
            return
        class_name = self.arg(1)
        interface_definition = "public class " + class_name + " {\n}"
        self.create_java_file(class_name, interface_definition)

def get_haskell_module_prefix(directory: str) -> str:
    prefix = directory.replace(".", "").replace(os.path.sep, ".")
    sub = prefix.split("src.", 1)
    if len(sub) > 1:
        return sub[1] + "."
    sub = prefix.split("test.", 1)
    if len(sub) > 1:
        return sub[1] + "."
    sub = prefix.split("lib.", 1)
    if len(sub) > 1:
        return sub[1] + "."
    return ""

class NewHaskellModule(Command):
    def execute(self):
        if not self.arg(1):
            return
        module_name = self.arg(1)
        module_splits = module_name.split(".")
        file_name = module_splits[-1]
        module_directories = os.path.join(*module_splits[:-1]) if len(module_splits) > 1 else ""
        cwd = self.fm.thisdir
        module_path = os.path.join(cwd.path, module_directories)
        if not os.path.isdir(module_path):
            os.makedirs(module_path)
        file_path = os.path.join(module_path, file_name + ".hs")
        module_name = get_haskell_module_prefix(module_path) + file_name
        module_line = "module " + module_name + " () where\n\n"
        with open(file_path,"w") as file:
            file.write(module_line)

class extract_here(Command):
    def execute(self):
        """ extract selected files to current directory."""
        cwd = self.fm.thisdir
        marked_files = tuple(cwd.get_selection())

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = marked_files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-x', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        self.fm.copy_buffer.clear()
        self.fm.cut_buffer = False
        if len(marked_files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(
                one_file.dirname)
        obj = CommandLoader(args=['aunpack'] + au_flags
                            + [f.path for f in marked_files], descr=descr,
                            read=True)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

class empty(Command):
    """:empty

    Empties the trash directory ~/.Trash
    """

    def execute(self):
        self.fm.run("rm -rf /home/myname/.Trash/{*,.[^.]*}")

class compress(Command):
    def execute(self):
        """ Compress marked files to current directory """
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        if not marked_files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        original_path = cwd.path
        parts = self.line.split()
        au_flags = parts[1:]

        descr = "compressing files in: " + os.path.basename(parts[1])
        obj = CommandLoader(args=['apack'] + au_flags + \
                [os.path.relpath(f.path, cwd.path) for f in marked_files], descr=descr, read=True)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

    def tab(self, tabnum):
        """ Complete with current folder name """

        extension = ['.zip', '.tar.gz', '.rar', '.7z']
        return ['compress ' + os.path.basename(self.fm.thisdir.path) + ext for ext in extension]
