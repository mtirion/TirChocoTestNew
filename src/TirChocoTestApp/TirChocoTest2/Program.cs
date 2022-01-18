using System.Reflection;

Console.WriteLine("This is another test application.\n");

Console.WriteLine($"Main (File) Version: {Assembly.GetEntryAssembly().GetCustomAttribute<AssemblyFileVersionAttribute>().Version}");
Console.WriteLine($"Assembly Version: {Assembly.GetEntryAssembly().GetName().Version}");
Console.WriteLine($"Product (Info) Version: {Assembly.GetEntryAssembly().GetCustomAttribute<AssemblyInformationalVersionAttribute>().InformationalVersion}");
