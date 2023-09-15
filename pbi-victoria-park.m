let
    Source = Json.Document(Web.Contents("https://api.waqi.info/api/feed/@14598/aqi.json")),
    #"Converted to Table" = Table.FromRecords({Source}),
    #"Expanded rxs" = Table.ExpandRecordColumn(#"Converted to Table", "rxs", {"obs", "status", "ver"}, {"rxs.obs", "rxs.status", "rxs.ver"}),
    #"Expanded rxs.obs" = Table.ExpandListColumn(#"Expanded rxs", "rxs.obs"),
    #"Expanded rxs.obs1" = Table.ExpandRecordColumn(#"Expanded rxs.obs", "rxs.obs", {"msg", "status", "cached"}, {"rxs.obs.msg", "rxs.obs.status", "rxs.obs.cached"}),
    #"Expanded rxs.obs.msg" = Table.ExpandRecordColumn(#"Expanded rxs.obs1", "rxs.obs.msg", {"aqi", "idx", "attributions", "city", "dominentpol", "iaqi", "time", "obs", "forecast", "xsync"}, {"rxs.obs.msg.aqi", "rxs.obs.msg.idx", "rxs.obs.msg.attributions", "rxs.obs.msg.city", "rxs.obs.msg.dominentpol", "rxs.obs.msg.iaqi", "rxs.obs.msg.time", "rxs.obs.msg.obs", "rxs.obs.msg.forecast", "rxs.obs.msg.xsync"}),
    #"Expanded rxs.obs.msg.city" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg", "rxs.obs.msg.city", {"geo", "name", "url"}, {"rxs.obs.msg.city.geo", "rxs.obs.msg.city.name", "rxs.obs.msg.city.url"}),
    #"Extracted Values" = Table.TransformColumns(#"Expanded rxs.obs.msg.city", {"rxs.obs.msg.city.geo", each Text.Combine(List.Transform(_, Text.From), ","), type text}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Extracted Values", "rxs.obs.msg.city.geo", Splitter.SplitTextByDelimiter(",", QuoteStyle.Csv), {"rxs.obs.msg.city.geo.1", "rxs.obs.msg.city.geo.2"}),
    #"Renamed Columns" = Table.RenameColumns(#"Split Column by Delimiter",{{"rxs.obs.msg.city.geo.1", "latitude"}, {"rxs.obs.msg.city.geo.2", "longitude"}}),
    #"Expanded rxs.obs.msg.iaqi" = Table.ExpandRecordColumn(#"Renamed Columns", "rxs.obs.msg.iaqi", {"h", "no2", "o3", "p", "pm10", "pm25", "t", "w", "wg"}, {"rxs.obs.msg.iaqi.h", "rxs.obs.msg.iaqi.no2", "rxs.obs.msg.iaqi.o3", "rxs.obs.msg.iaqi.p", "rxs.obs.msg.iaqi.pm10", "rxs.obs.msg.iaqi.pm25", "rxs.obs.msg.iaqi.t", "rxs.obs.msg.iaqi.w", "rxs.obs.msg.iaqi.wg"}),
    #"Expanded rxs.obs.msg.iaqi.h" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.iaqi", "rxs.obs.msg.iaqi.h", {"v", "t"}, {"humidity", "rxs.obs.msg.iaqi.h.t"}),
    #"Expanded rxs.obs.msg.iaqi.no2" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.iaqi.h", "rxs.obs.msg.iaqi.no2", {"v", "t"}, {"no2", "rxs.obs.msg.iaqi.no2.t"}),
    #"Expanded rxs.obs.msg.iaqi.o3" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.iaqi.no2", "rxs.obs.msg.iaqi.o3", {"v", "t"}, {"ozone", "rxs.obs.msg.iaqi.o3.t"}),
    #"Expanded rxs.obs.msg.iaqi.p" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.iaqi.o3", "rxs.obs.msg.iaqi.p", {"v", "t"}, {"pressure", "rxs.obs.msg.iaqi.p.t"}),
    #"Expanded rxs.obs.msg.iaqi.pm10" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.iaqi.p", "rxs.obs.msg.iaqi.pm10", {"v", "t"}, {"pm10", "rxs.obs.msg.iaqi.pm10.t"}),
    #"Expanded rxs.obs.msg.iaqi.pm25" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.iaqi.pm10", "rxs.obs.msg.iaqi.pm25", {"v", "t"}, {"pm25", "rxs.obs.msg.iaqi.pm25.t"}),
    #"Expanded rxs.obs.msg.iaqi.t" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.iaqi.pm25", "rxs.obs.msg.iaqi.t", {"v", "t"}, {"temp", "rxs.obs.msg.iaqi.t.t"}),
    #"Expanded rxs.obs.msg.iaqi.w" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.iaqi.t", "rxs.obs.msg.iaqi.w", {"v", "t"}, {"wind", "rxs.obs.msg.iaqi.w.t"}),
    #"Expanded rxs.obs.msg.iaqi.wg" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.iaqi.w", "rxs.obs.msg.iaqi.wg", {"v", "t"}, {"gust", "rxs.obs.msg.iaqi.wg.t"}),
    #"Expanded rxs.obs.msg.time" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.iaqi.wg", "rxs.obs.msg.time", {"s", "tz", "v", "iso"}, {"rxs.obs.msg.time.s", "rxs.obs.msg.time.tz", "rxs.obs.msg.time.v", "rxs.obs.msg.time.iso"}),
    #"Expanded rxs.obs.msg.obs" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.time", "rxs.obs.msg.obs", {"h", "no2", "o3", "p", "pm10", "pm25", "t", "w", "wg"}, {"rxs.obs.msg.obs.h", "rxs.obs.msg.obs.no2", "rxs.obs.msg.obs.o3", "rxs.obs.msg.obs.p", "rxs.obs.msg.obs.pm10", "rxs.obs.msg.obs.pm25", "rxs.obs.msg.obs.t", "rxs.obs.msg.obs.w", "rxs.obs.msg.obs.wg"}),
    #"Expanded rxs.obs.msg.obs.h" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.obs", "rxs.obs.msg.obs.h", {"e", "s", "d", "m", "v"}, {"rxs.obs.msg.obs.h.e", "rxs.obs.msg.obs.h.s", "rxs.obs.msg.obs.h.d", "rxs.obs.msg.obs.h.m", "rxs.obs.msg.obs.h.v"}),
    #"Expanded rxs.obs.msg.obs.no2" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.obs.h", "rxs.obs.msg.obs.no2", {"e", "s", "d", "m", "v"}, {"rxs.obs.msg.obs.no2.e", "rxs.obs.msg.obs.no2.s", "rxs.obs.msg.obs.no2.d", "rxs.obs.msg.obs.no2.m", "rxs.obs.msg.obs.no2.v"}),
    #"Expanded rxs.obs.msg.obs.o3" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.obs.no2", "rxs.obs.msg.obs.o3", {"e", "s", "d", "m", "v"}, {"rxs.obs.msg.obs.o3.e", "rxs.obs.msg.obs.o3.s", "rxs.obs.msg.obs.o3.d", "rxs.obs.msg.obs.o3.m", "rxs.obs.msg.obs.o3.v"}),
    #"Expanded rxs.obs.msg.obs.p" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.obs.o3", "rxs.obs.msg.obs.p", {"e", "s", "d", "m", "v"}, {"rxs.obs.msg.obs.p.e", "rxs.obs.msg.obs.p.s", "rxs.obs.msg.obs.p.d", "rxs.obs.msg.obs.p.m", "rxs.obs.msg.obs.p.v"}),
    #"Expanded rxs.obs.msg.obs.pm10" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.obs.p", "rxs.obs.msg.obs.pm10", {"e", "s", "d", "m", "v"}, {"rxs.obs.msg.obs.pm10.e", "rxs.obs.msg.obs.pm10.s", "rxs.obs.msg.obs.pm10.d", "rxs.obs.msg.obs.pm10.m", "rxs.obs.msg.obs.pm10.v"}),
    #"Expanded rxs.obs.msg.obs.pm25" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.obs.pm10", "rxs.obs.msg.obs.pm25", {"e", "s", "d", "m", "v"}, {"rxs.obs.msg.obs.pm25.e", "rxs.obs.msg.obs.pm25.s", "rxs.obs.msg.obs.pm25.d", "rxs.obs.msg.obs.pm25.m", "rxs.obs.msg.obs.pm25.v"}),
    #"Expanded rxs.obs.msg.obs.t" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.obs.pm25", "rxs.obs.msg.obs.t", {"e", "s", "d", "m", "v"}, {"rxs.obs.msg.obs.t.e", "rxs.obs.msg.obs.t.s", "rxs.obs.msg.obs.t.d", "rxs.obs.msg.obs.t.m", "rxs.obs.msg.obs.t.v"}),
    #"Expanded rxs.obs.msg.obs.w" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.obs.t", "rxs.obs.msg.obs.w", {"e", "s", "d", "m", "v"}, {"rxs.obs.msg.obs.w.e", "rxs.obs.msg.obs.w.s", "rxs.obs.msg.obs.w.d", "rxs.obs.msg.obs.w.m", "rxs.obs.msg.obs.w.v"}),
    #"Expanded rxs.obs.msg.obs.wg" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.obs.w", "rxs.obs.msg.obs.wg", {"e", "s", "d", "m", "v"}, {"rxs.obs.msg.obs.wg.e", "rxs.obs.msg.obs.wg.s", "rxs.obs.msg.obs.wg.d", "rxs.obs.msg.obs.wg.m", "rxs.obs.msg.obs.wg.v"}),
    #"Expanded rxs.obs.msg.forecast" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.obs.wg", "rxs.obs.msg.forecast", {"daily", "hourly"}, {"rxs.obs.msg.forecast.daily", "rxs.obs.msg.forecast.hourly"}),
    #"Expanded rxs.obs.msg.forecast.daily" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.forecast", "rxs.obs.msg.forecast.daily", {"o3", "pm10", "pm25"}, {"rxs.obs.msg.forecast.daily.o3", "rxs.obs.msg.forecast.daily.pm10", "rxs.obs.msg.forecast.daily.pm25"}),
    #"Expanded rxs.obs.msg.forecast.hourly" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.forecast.daily", "rxs.obs.msg.forecast.hourly", {}, {}),
    #"Expanded rxs.obs.msg.xsync" = Table.ExpandRecordColumn(#"Expanded rxs.obs.msg.forecast.hourly", "rxs.obs.msg.xsync", {"gen"}, {"rxs.obs.msg.xsync.gen"}),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded rxs.obs.msg.xsync",{{"dt", type text}, {"rxs.obs.msg.aqi", Int64.Type}, {"rxs.obs.msg.idx", Int64.Type}, {"rxs.obs.msg.attributions", type any}, {"latitude", type number}, {"longitude", type number}, {"rxs.obs.msg.city.name", type text}, {"rxs.obs.msg.city.url", type text}, {"rxs.obs.msg.dominentpol", type text}, {"humidity", type number}, {"rxs.obs.msg.iaqi.h.t", type datetime}, {"no2", type number}, {"rxs.obs.msg.iaqi.no2.t", type datetime}, {"ozone", type number}, {"rxs.obs.msg.iaqi.o3.t", type datetime}, {"pressure", type number}, {"rxs.obs.msg.iaqi.p.t", type datetime}, {"pm10", Int64.Type}, {"rxs.obs.msg.iaqi.pm10.t", type datetime}, {"pm25", Int64.Type}, {"rxs.obs.msg.iaqi.pm25.t", type datetime}, {"temp", type number}, {"rxs.obs.msg.iaqi.t.t", type datetime}, {"wind", type number}, {"rxs.obs.msg.iaqi.w.t", type datetime}, {"gust", type number}, {"rxs.obs.msg.iaqi.wg.t", type datetime}, {"rxs.obs.msg.time.s", type datetime}, {"rxs.obs.msg.time.tz", type text}, {"rxs.obs.msg.time.v", Int64.Type}, {"rxs.obs.msg.time.iso", type datetimezone}, {"rxs.obs.msg.obs.h.e", Int64.Type}, {"rxs.obs.msg.obs.h.s", type datetime}, {"rxs.obs.msg.obs.h.d", Int64.Type}, {"rxs.obs.msg.obs.h.m", Int64.Type}, {"rxs.obs.msg.obs.h.v", type any}, {"rxs.obs.msg.obs.no2.e", Int64.Type}, {"rxs.obs.msg.obs.no2.s", type datetime}, {"rxs.obs.msg.obs.no2.d", Int64.Type}, {"rxs.obs.msg.obs.no2.m", Int64.Type}, {"rxs.obs.msg.obs.no2.v", type any}, {"rxs.obs.msg.obs.o3.e", Int64.Type}, {"rxs.obs.msg.obs.o3.s", type datetime}, {"rxs.obs.msg.obs.o3.d", Int64.Type}, {"rxs.obs.msg.obs.o3.m", Int64.Type}, {"rxs.obs.msg.obs.o3.v", type any}, {"rxs.obs.msg.obs.p.e", Int64.Type}, {"rxs.obs.msg.obs.p.s", type datetime}, {"rxs.obs.msg.obs.p.d", Int64.Type}, {"rxs.obs.msg.obs.p.m", Int64.Type}, {"rxs.obs.msg.obs.p.v", type any}, {"rxs.obs.msg.obs.pm10.e", Int64.Type}, {"rxs.obs.msg.obs.pm10.s", type datetime}, {"rxs.obs.msg.obs.pm10.d", Int64.Type}, {"rxs.obs.msg.obs.pm10.m", Int64.Type}, {"rxs.obs.msg.obs.pm10.v", type any}, {"rxs.obs.msg.obs.pm25.e", Int64.Type}, {"rxs.obs.msg.obs.pm25.s", type datetime}, {"rxs.obs.msg.obs.pm25.d", Int64.Type}, {"rxs.obs.msg.obs.pm25.m", Int64.Type}, {"rxs.obs.msg.obs.pm25.v", type any}, {"rxs.obs.msg.obs.t.e", Int64.Type}, {"rxs.obs.msg.obs.t.s", type datetime}, {"rxs.obs.msg.obs.t.d", Int64.Type}, {"rxs.obs.msg.obs.t.m", Int64.Type}, {"rxs.obs.msg.obs.t.v", type any}, {"rxs.obs.msg.obs.w.e", Int64.Type}, {"rxs.obs.msg.obs.w.s", type datetime}, {"rxs.obs.msg.obs.w.d", Int64.Type}, {"rxs.obs.msg.obs.w.m", Int64.Type}, {"rxs.obs.msg.obs.w.v", type any}, {"rxs.obs.msg.obs.wg.e", Int64.Type}, {"rxs.obs.msg.obs.wg.s", type datetime}, {"rxs.obs.msg.obs.wg.d", Int64.Type}, {"rxs.obs.msg.obs.wg.m", Int64.Type}, {"rxs.obs.msg.obs.wg.v", type any}, {"rxs.obs.msg.forecast.daily.o3", type any}, {"rxs.obs.msg.forecast.daily.pm10", type any}, {"rxs.obs.msg.forecast.daily.pm25", type any}, {"rxs.obs.msg.xsync.gen", Int64.Type}, {"rxs.obs.status", type text}, {"rxs.obs.cached", type text}, {"rxs.status", type text}, {"rxs.ver", Int64.Type}})
in
    #"Changed Type"