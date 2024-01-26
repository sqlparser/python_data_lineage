# python3
import webbrowser
import jpype
import sys
def indexOf(args, arg):
    try:
        return args.index(arg)
    except:
        return -1

def save_to_file(file_name, contents):
    fh = open(file_name, 'w')
    fh.write(contents)
    fh.close()
def call_dataFlowAnalyzer(args):
    # Start the Java Virtual Machine (JVM)
    widget_server_url = "http://localhost:8000"
    jvm = jpype.getDefaultJVMPath()
    jar = "-Djava.class.path=jar/gudusoft.gsqlparser-2.8.5.8.jar"
    jpype.startJVM(jvm, "-ea", jar)

    try:
        TGSqlParser = jpype.JClass("gudusoft.gsqlparser.TGSqlParser")
        DataFlowAnalyzer = jpype.JClass("gudusoft.gsqlparser.dlineage.DataFlowAnalyzer")
        ProcessUtility = jpype.JClass("gudusoft.gsqlparser.dlineage.util.ProcessUtility")
        JSON = jpype.JClass("gudusoft.gsqlparser.util.json.JSON")
        XML2Model = jpype.JClass("gudusoft.gsqlparser.dlineage.util.XML2Model")
        RemoveDataflowFunction = jpype.JClass("gudusoft.gsqlparser.dlineage.util.RemoveDataflowFunction")
        File = jpype.JClass("java.io.File")
        sqlFiles = None
        EDbVendor = jpype.JClass("gudusoft.gsqlparser.EDbVendor")
        vendor = EDbVendor.dbvoracle
        index = indexOf(args, "/t")
        if index != -1 and len(args) > index + 1:
          vendor = TGSqlParser.getDBVendorByName(args[index + 1])
        if indexOf(args, "/version") != -1:
           print("Version: " + DataFlowAnalyzer.getVersion())
           print("Release Date: " + DataFlowAnalyzer.getReleaseDate())
           return

        if indexOf(args, "/f") != -1 and len(args) > indexOf(args, "/f") + 1:
           sqlFiles = File(args[indexOf(args, "/f") + 1])
           if not sqlFiles.exists() or not sqlFiles.isFile():
             print(args[indexOf(args, "/f") + 1] + " is not a valid file.")
             return
        elif indexOf(args, "/d") != -1 and len(args) > indexOf(args, "/d") + 1:
           sqlFiles = File(args[indexOf(args, "/d") + 1])
           if not sqlFiles.exists() or not sqlFiles.isDirectory():
              print(args[indexOf(args, "/d") + 1] + " is not a valid directory.")
              return
        else:
         print("Please specify a sql file path or directory path to analyze dlineage.")
         return
        simple = indexOf(args, "/s") != -1
        ignoreTemporaryTable = indexOf(args, "/withTemporaryTable") == -1
        ignoreResultSets = indexOf(args, "/i") != -1
        showJoin = indexOf(args, "/j") != -1
        transform = indexOf(args, "/transform") != -1
        transformCoordinate = transform and (indexOf(args, "/coor") != -1)
        textFormat = False
        linkOrphanColumnToFirstTable = indexOf(args, "/lof") != -1
        ignoreCoordinate = indexOf(args, "/ic") != -1
        showImplicitSchema = indexOf(args, "/showImplicitSchema") != -1

        if simple:
            textFormat = indexOf(args, "/text") != -1
        traceView = indexOf(args, "/traceView") != -1
        if traceView:
            simple = True
        jsonFormat = indexOf(args, "/json") != -1
        stat = indexOf(args, "/stat") != -1
        ignoreFunction = indexOf(args, "/if") != -1
        topselectlist = indexOf(args, "/topselectlist") != -1

        if indexOf(args, "/s") != -1 and indexOf(args, "/topselectlist") != -1:
            simple = True
            topselectlist = True
        tableLineage = indexOf(args, "/tableLineage") != -1
        csv = indexOf(args, "/csv") != -1
        delimiter = args.get(indexOf(args, "/delimiter") + 1) if indexOf(args, "/delimiter") != -1 and len(args) > indexOf(args, "/delimiter") + 1 else ","
        if tableLineage:
            simple = False
            ignoreResultSets = False

        sqlenv = None
        if indexOf(args, "/env") != -1 and len(args) > indexOf(args, "/env") + 1:
            metadataFile = File(args[indexOf(args, "/env") + 1])
            if metadataFile.exists():
                TJSONSQLEnvParser = jpype.JClass("gudusoft.gsqlparser.sqlenv.parser.TJSONSQLEnvParser")
                jsonSQLEnvParser = TJSONSQLEnvParser(None, None, None)
                SQLUtil = jpype.JClass("gudusoft.gsqlparser.util.SQLUtil")
                envs = jsonSQLEnvParser.parseSQLEnv(vendor, SQLUtil.getFileContent(metadataFile))
                if envs != None and envs.length > 0:
                   sqlenv = envs[0]
        dlineage = DataFlowAnalyzer(sqlFiles, vendor, simple)
        if sqlenv != None:
            dlineage.setSqlEnv(sqlenv)
        dlineage.setTransform(transform)
        dlineage.setTransformCoordinate(transformCoordinate)
        dlineage.setShowJoin(showJoin)
        dlineage.setIgnoreRecordSet(ignoreResultSets)
        if ignoreResultSets and not ignoreFunction:
           dlineage.setSimpleShowFunction(True)
        dlineage.setLinkOrphanColumnToFirstTable(linkOrphanColumnToFirstTable)
        dlineage.setIgnoreCoordinate(ignoreCoordinate)
        dlineage.setSimpleShowTopSelectResultSet(topselectlist)
        dlineage.setShowImplicitSchema(showImplicitSchema)
        dlineage.setIgnoreTemporaryTable(ignoreTemporaryTable)
        if simple:
            dlineage.setShowCallRelation(True)
        dlineage.setShowConstantTable(indexOf(args, "/showConstant") != -1)
        dlineage.setShowCountTableColumn(indexOf(args, "/treatArgumentsInCountFunctionAsDirectDataflow") != -1)

        if indexOf(args, "/defaultDatabase") != -1:
            dlineage.getOption().setDefaultDatabase(args[indexOf(args, "/defaultDatabase") + 1])
        if indexOf(args, "/defaultSchema") != -1:
            dlineage.getOption().setDefaultSchema(args[indexOf(args, "/defaultSchema") + 1])
        if indexOf(args, "/showResultSetTypes") != -1:
            resultSetTypes = args[indexOf(args, "/showResultSetTypes") + 1]
            if resultSetTypes != None:
                dlineage.getOption().showResultSetTypes(resultSetTypes.split(","))

        if indexOf(args, "/filterRelationTypes") != -1:
            dlineage.getOption().filterRelationTypes(args[indexOf(args, "/filterRelationTypes") + 1])
        if simple and not jsonFormat:
            dlineage.setTextFormat(textFormat)

        result = None
        dataflow = None
        if tableLineage:
            dlineage.generateDataFlow()
            originDataflow = dlineage.getDataFlow()
            if csv:
                dataflow = ProcessUtility.generateTableLevelLineage(dlineage, originDataflow)
                result = ProcessUtility.generateTableLevelLineageCsv(dlineage, originDataflow, delimiter)
            else:
                dataflow = ProcessUtility.generateTableLevelLineage(dlineage, originDataflow)
                if jsonFormat:
                    model = DataFlowAnalyzer.getSqlflowJSONModel(dataflow, vendor)
                    result = JSON.toJSONString(model)
                else:
                    result = XML2Model.saveXML(dataflow)
        else:
            result = dlineage.generateDataFlow()
            dataflow = dlineage.getDataFlow()
            if csv:
                dataflow = dlineage.getDataFlow()
                result = ProcessUtility.generateColumnLevelLineageCsv(dlineage, dataflow, delimiter)
            elif jsonFormat:
                dataflow = dlineage.getDataFlow()
                if ignoreFunction:
                    dataflow = RemoveDataflowFunction().removeFunction(dataflow, vendor)
                model = DataFlowAnalyzer.getSqlflowJSONModel(dataflow, vendor)
                result = JSON.toJSONString(model)
            elif traceView:
                dataflow = dlineage.getDataFlow()
                result = dlineage.traceView()
            elif ignoreFunction and result.trim().startsWith("<?xml"):
                dataflow = dlineage.getDataFlow()
                dataflow = RemoveDataflowFunction().removeFunction(dataflow, vendor)
                result = XML2Model.saveXML(dataflow)

        if result != None:
            print(result)
        if dataflow != None and indexOf(args, "/graph") != -1:
            EDbVendor = jpype.JClass("gudusoft.gsqlparser.EDbVendor")
            vendor = EDbVendor.dbvoracle
            DataFlowGraphGenerator = jpype.JClass("gudusoft.gsqlparser.dlineage.graph.DataFlowGraphGenerator")
            generator = DataFlowGraphGenerator()
            result = generator.genDlineageGraph(vendor, False, dataflow)
            save_to_file("widget/json/lineageGraph.json", str(result))
            webbrowser.open_new(widget_server_url)
        errors = dlineage.getErrorMessages()
        if not errors.isEmpty():
            print("Error log:\n")
        for err in errors:
            print(err.getErrorMessage())

    finally:
        # Shutdown the JVM when done
        jpype.shutdownJVM()


if __name__ == "__main__":
    args = sys.argv
    if len(args) < 2:
      print("Usage: java DataFlowAnalyzer [/f <path_to_sql_file>] [/d <path_to_directory_includes_sql_files>] [/stat] [/s [/topselectlist] [/text] [/withTemporaryTable]] [/i] [/showResultSetTypes <resultset_types>] [/ic] [/lof] [/j] [/json] [/traceView] [/t <database type>] [/o <output file path>] [/version] [/env <path_to_metadata.json>]  [/tableLineage [/csv [/delimeter <delimeter>]]] [/transform [/coor]] [/showConstant] [/treatArgumentsInCountFunctionAsDirectDataflow] [/filterRelationTypes <relationTypes>]")
      print("/f: Optional, the full path to SQL file.")
      print("/d: Optional, the full path to the directory includes the SQL files.")
      print("/j: Optional, return the result including the join relation.")
      print("/s: Optional, simple output, ignore the intermediate results.")
      print("/topselectlist: Optional, simple output with top select results.")
      print("/withTemporaryTable: Optional, simple output with the temporary tables.")
      print("/i: Optional, the same as /s option, but will keep the resultset generated by the SQL function, this parameter will have the same effect as /s /topselectlist + keep resultset generated by the sql function.")
      print("/showResultSetTypes: Optional, simple output with specify resultset types, separate with commas, resultset types contains array, struct, result_of, cte, insert_select, update_select, merge_update, merge_insert, output, update_set,\r\n"
            + "	pivot_table, unpivot_table, alias, rs, function, case_when")
      print("/if: Optional, keep all the intermediate resultset, but remove the resultset generated by the SQL function")
      print("/ic: Optional, ignore the coordinates in the output.")
      print("/lof: Option, link orphan column to the first table.")
      print("/traceView: Optional, only output the name of source tables and views, ignore all intermedidate data.")
      print("/text: Optional, this option is valid only /s is used, output the column dependency in text mode.")
      print("/json: Optional, print the json format output.")
      print("/tableLineage [/csv /delimiter]: Optional, output tabel level lineage.")
      print("/csv: Optional, output column level lineage in csv format.")
      print("/delimiter: Optional, the delimiter of output column level lineage in csv format.")
      print("/t: Option, set the database type. "
        + "Support access,bigquery,couchbase,dax,db2,greenplum,hana,hive,impala,informix,mdx,mssql,\n"
        + "sqlserver,mysql,netezza,odbc,openedge,oracle,postgresql,postgres,redshift,snowflake,\n"
        + "sybase,teradata,soql,vertica\n, " + "the default value is oracle")
      print("/env: Optional, specify a metadata.json to get the database metadata information.")
      print("/transform: Optional, output the relation transform code.")
      print("/coor: Optional, output the relation transform coordinate, but not the code.")
      print("/defaultDatabase: Optional, specify the default schema.")
      print("/defaultSchema: Optional, specify the default schema.")
      print("/showImplicitSchema: Optional, show implicit schema.")
      print("/showConstant: Optional, show constant table.")
      print("/treatArgumentsInCountFunctionAsDirectDataflow: Optional, treat arguments in count function as direct dataflow.")
      print("/filterRelationTypes: Optional, support fdd, fdr, join, call, er, multiple relatoin types separated by commas")
      sys.exit(0)

    call_dataFlowAnalyzer(args)
