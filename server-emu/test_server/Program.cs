using System;
using System.Diagnostics;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            string PathMap="";
            DateTime TimeBegin;
            TimeBegin = DateTime.Now;
            Boolean streaming = false;
            Console.WriteLine("Begin test: " + TimeBegin.ToString("HH:mm:ss.ms"));
            if (args.Length > 0)
            {
                int i;
                for (i = 0; i < args.Length; i++ )
                {
                    Console.WriteLine(args[i]);
                }

                String PrefixCommandLine="";
                for (i = 1; i < args.Length-1; i++)
                {
                    if (args[i] == "--verbose") streaming = true;
                    PrefixCommandLine = PrefixCommandLine + args[i] + " ";
                }
                PathMap = args[args.Length-1];
                string[] files = System.IO.Directory.GetFiles(PathMap);
                foreach (string NameFile in files)
                {
                    Console.WriteLine();
                    Console.WriteLine("Map: " + NameFile);
                    String CommandLine;
                    if (streaming)
                    {
                      CommandLine = PrefixCommandLine;
                    }
                    else
                    {
                        CommandLine = PrefixCommandLine + NameFile;
                    }
                    //Console.WriteLine(PathMap);
                    Console.WriteLine("Command line:" + CommandLine);
                    Process proc = new Process();
                    proc.StartInfo.UseShellExecute = false;
                    proc.StartInfo.RedirectStandardOutput = true;
                    proc.StartInfo.RedirectStandardInput = true;
                    proc.StartInfo.RedirectStandardError = true;
                    proc.StartInfo.FileName = args[0]; //run rubi script
                    proc.StartInfo.Arguments = CommandLine;
                    DateTime StartProc = DateTime.Now;
                    proc.Start();
                    if (streaming)
                    {
                        string line;
                        using (StreamReader myStreaReader = new StreamReader(NameFile))
                        {
                            while ((line = myStreaReader.ReadLine()) != null)
                            {
                                proc.StandardInput.WriteLine(line);
                                //Console.WriteLine(line);
                            }
                        }
                        proc.StandardInput.Write("");
                        proc.StandardInput.Close();
                    }
                    if (!proc.WaitForExit(150000)) proc.Kill();//150sec
                    DateTime EndProc = DateTime.Now;
                    string strout = proc.StandardOutput.ReadToEnd();
                    Console.WriteLine("Proc begin:" + StartProc.ToString("HH:mm:ss.ms"));
                    Console.WriteLine("Return string");
                    Console.WriteLine(strout);
                    TimeSpan WorkTime = EndProc - StartProc;
                    Console.WriteLine("Proc run:" + WorkTime.ToString());
                }
                Console.WriteLine("Finish tests, press any key to exit");
                Console.ReadKey();
            }
            else
            {
                Console.WriteLine("You must enter command line: <ruby simulator program> <parameters> <path to folder with maps>");
                Console.ReadKey();
            }
        }
    }
}
