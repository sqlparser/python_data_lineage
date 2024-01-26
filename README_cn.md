### 在Python中如何使用数据血缘分析工具？

## step 1 环境准备
  * 安装python3
  * 安装 java jdk1.8

## step 2 打开web服务
 切换到本项目widget目录，执行以下命令启动web服务：

 `python -m http.server 8000`
  
  浏览器内打开以下网址验证是否启动成功：http://localhost:8000/
  
  注意：如果要修改8000端口，需要同时在dlineage.py里修改widget_server_url

## step 3 执行python脚本
  切换到本项目根目录，即dlineage.py所在目录，执行以下命令：

  `python dlineage.py /f test.sql /graph`
   
   此命令，会将test.sql进行血缘分析，并打开一个浏览器页面，图形化方式展示血缘分析结果。
   
   dlineage.py 支持的命令参数说明：

      /f: 可选, sql文件.

      /d: 可选, 包含sql文件的文件夹路径.

      /j: 可选, 返回包含join关系的结果.

      /s: 可选, 简单输出，忽略中间结果.

      /topselectlist: 可选, 简单输出，包含最顶端的输出结果.

      /withTemporaryTable: 可选, 简单输出，包含临时表.

      /i: 可选, 与/s选项相同，但将保留SQL函数生成的结果集，此参数将与/s/topselectlist+keep SQL函数生成结果集具有相同的效果。

      /showResultSetTypes: 可选, 带有指定结果集类型的简单输出，用逗号分隔, 结果集类型有： array, struct, result_of, cte, insert_select, update_select, merge_update, merge_insert, output, update_set pivot_table, unpivot_table, alias, rs, function, case_when

      /if: 可选, 保留所有中间结果集，但删除 SQL 函数生成的结果集。

      /ic: 可选, 忽略输出中的坐标.

      /lof: 必选, 将孤立列链接到第一个表.

      /traceView: 可选,只输出源表和视图的名称，忽略所有中间数据.

      /text: 可选, 如果只使用/s 选项，则在文本模式下输出列依赖项.

      /json: 可选, 打印json格式输出.

      /tableLineage [/csv /delimiter]: 可选, 输出表级血缘关系.

      /csv: 可选, 输出csv格式的列一级的血缘关系.

      /delimiter: 可选, 输出csv格式的分隔符.

      /t: 必选, 指定数据库类型. 
        支持 access,bigquery,couchbase,dax,db2,greenplum, gaussdb, hana,hive,impala,informix,mdx,mssql,
        sqlserver,mysql,netezza,odbc,openedge,oracle,postgresql,postgres,redshift,snowflake,
        sybase,teradata,soql,vertica the default value is oracle

      /env: 可选, 指定一个 metadata.json 来获取数据库元数据信息.

      /transform: 可选, 输出关系转换码.

      /coor: 可选, 输出关系转换坐标，但不输出代码.

      /defaultDatabase: 可选, 指定默认database.

      /defaultSchema: 可选, 指定默认schema.

      /showImplicitSchema: 可选, 显示间接schema.

      /showConstant: 可选, 显示常量.

      /treatArgumentsInCountFunctionAsDirectDataflow: 可选,将 count 函数中的参数视为直接数据流.

      /filterRelationTypes: 可选, 过滤关系类型，支持 fdd，fdr，join，call，er，如果有多个关系类型用英文半角逗号分隔.

      /graph: 可选, 打开一个浏览器页面，图形化方式展示血缘分析结果