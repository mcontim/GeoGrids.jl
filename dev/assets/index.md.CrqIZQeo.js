import{_ as e,c as s,a7 as i,G as t,B as n,o}from"./chunks/framework.PIQApXt7.js";const E=JSON.parse('{"title":"GeoGrids.jl","description":"","frontmatter":{},"headers":[],"relativePath":"index.md","filePath":"index.md","lastUpdated":null}'),r={name:"index.md"};function h(c,l,p,d,u,k){const a=n("VuePlotly");return o(),s("div",null,[l[0]||(l[0]=i(`<h1 id="geogrids-jl" tabindex="-1">GeoGrids.jl <a class="header-anchor" href="#geogrids-jl" aria-label="Permalink to &quot;GeoGrids.jl&quot;">​</a></h1><p><strong>GeoGrids.jl</strong> is a Julia package for generating and manipulating geographical grids, particularly useful for system-level simulations and geospatial analysis. The package provides tools for creating various types of grids, defining geographical regions, and performing spatial operations.</p><h2 id="features" tabindex="-1">Features <a class="header-anchor" href="#features" aria-label="Permalink to &quot;Features&quot;">​</a></h2><ul><li><strong>Grid Generation</strong>: Create uniform point distributions using icosahedral, rectangular, or vector grid patterns</li><li><strong>Region Definition</strong>: Define areas of interest using latitude belts, country boundaries, or custom polygons</li><li><strong>Tessellation</strong>: Generate cell layouts with hexagonal or icosahedral patterns</li><li><strong>Filtering</strong>: Efficiently filter and group points based on geographical regions</li></ul><h2 id="Quick-Example" tabindex="-1">Quick Example <a class="header-anchor" href="#Quick-Example" aria-label="Permalink to &quot;Quick Example {#Quick-Example}&quot;">​</a></h2><p>Here&#39;s a simple example that demonstrates some key features of GeoGrids.jl:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> GeoGrids</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> PlotlyBase</span></span>
<span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> PlotlyDocumenter</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;"># Create a geographical region for France</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">region </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> GeoRegion</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(admin</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;France&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;"># Generate a hexagonal cell layout</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">centers, tiles </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> generate_tesselation</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(region, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">75e3</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">, </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">HEX</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(), </span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">EO</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">())</span></span>
<span class="line"></span>
<span class="line"><span style="--shiki-light:#6A737D;--shiki-dark:#6A737D;"># Create the plot</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">plot </span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;"> plot_geo_cells</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    centers,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    tiles;</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    title</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;75km Hexagonal Cells Over France&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">,</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">    kwargs_layout</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(;geo_fitbounds</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">=</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;locations&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div>`,7)),t(a,{data:[{showlegend:!1,mode:"lines",type:"scattergeo",name:"Cell Contour",lat:[51.82466697156079,51.01790843539498,50.66653801864529,50.27632638091986,51.08259727092074,51.398868953424014,51.82466697156079,null,48.754139534703796,49.50870384382354,49.887427203097204,50.22940885013417,49.476722272940314,49.068026501462676,48.754139534703796,null,50.27632638091986,50.66653801864529,49.887427203097204,49.50870384382354,49.15044744074615,49.929065746549895,50.27632638091986,null,49.52515179160301,50.328293097762746,50.64286516090133,51.08259727092074,50.27632638091986,49.929065746549895,49.52515179160301,null,49.52515179160301,49.17967890305222,48.76488135154136,49.56264496830002,49.87773357750293,50.328293097762746,49.52515179160301,null,48.60783663796241,49.04479864444295,49.29537276722558,48.59227139102363,48.12891759441668,47.898939319705285,48.60783663796241,null,49.068026501462676,49.476722272940314,49.772073415619445,49.04479864444295,48.60783663796241,48.336777866142,49.068026501462676,null,47.90695857586632,47.618338479105915,48.351066892503944,48.754139534703796,49.068026501462676,48.336777866142,47.90695857586632,null,48.7755615210191,49.15044744074615,49.50870384382354,48.754139534703796,48.351066892503944,48.021573414140114,48.7755615210191,null,48.40392631801471,49.17967890305222,49.52515179160301,49.929065746549895,49.15044744074615,48.7755615210191,48.40392631801471,null,48.41920991828067,48.76488135154136,49.17967890305222,48.40392631801471,48.030811086530306,47.64835578891185,48.41920991828067,null,49.103951878634774,49.56264496830002,48.76488135154136,48.41920991828067,47.99599034708787,48.78648298846641,49.103951878634774,null,48.78648298846641,47.99599034708787,47.64843791300812,47.218934360123015,48.0005798047664,48.32197850264478,48.78648298846641,null,48.336777866142,48.60783663796241,47.898939319705285,47.44398594642321,47.194763435910794,47.90695857586632,48.336777866142,null,47.1935475794237,47.618338479105915,47.90695857586632,47.194763435910794,46.74612095075225,46.480279766694096,47.1935475794237,null,46.890003241825625,47.62201573866626,48.021573414140114,48.351066892503944,47.618338479105915,47.1935475794237,46.890003241825625,null,48.40392631801471,48.7755615210191,48.021573414140114,47.62201573866626,47.27953184438836,48.030811086530306,48.40392631801471,null,48.030811086530306,47.27953184438836,46.88164999798214,46.52849996379755,47.275232910462506,47.64835578891185,48.030811086530306,null,47.64835578891185,47.275232910462506,46.88420645464408,47.64843791300812,47.99599034708787,48.41920991828067,47.64835578891185,null,46.480279766694096,46.74612095075225,46.05089328482953,45.58544456698631,45.34018728853918,46.03608115036776,46.480279766694096,null,46.03608115036776,45.75599952775379,46.46837313013329,46.890003241825625,47.1935475794237,46.480279766694096,46.03608115036776,null,46.46837313013329,46.15227094974459,46.88164999798214,47.27953184438836,47.62201573866626,46.890003241825625,46.46837313013329,null,46.13070321695247,46.52849996379755,46.88164999798214,46.15227094974459,45.73216530003879,45.40561838015831,46.13070321695247,null,45.7689419291363,46.509560069916596,46.88420645464408,47.275232910462506,46.52849996379755,46.13070321695247,45.7689419291363,null,46.11192916908697,46.509560069916596,45.7689419291363,45.369866778150374,45.00130241079496,45.73448028340135,46.11192916908697,null,45.58544456698631,44.90535449512425,44.42487278257158,44.19825768479557,44.87861509927988,45.34018728853918,45.58544456698631,null,44.619793613279036,45.31458969553324,45.75599952775379,46.03608115036776,45.34018728853918,44.87861509927988,44.619793613279036,null,45.75599952775379,45.31458969553324,45.02241112446197,45.73216530003879,46.15227094974459,46.46837313013329,45.75599952775379,null,45.40561838015831,45.73216530003879,45.02241112446197,44.582334415973,44.27998185710843,44.98561537537899,45.40561838015831,null,46.13070321695247,45.40561838015831,44.98561537537899,44.65050192265319,45.369866778150374,45.7689419291363,46.13070321695247,null,43.88735895435496,44.59979148875156,45.00130241079496,45.369866778150374,44.65050192265319,44.22937687763319,43.88735895435496,null,44.19825768479557,44.42487278257158,43.758310949424875,43.264359209643956,43.05466419811422,43.721107041218715,44.19825768479557,null,44.16063077020812,44.619793613279036,44.87861509927988,44.19825768479557,43.721107041218715,43.481589872981516,44.16063077020812,null,44.16063077020812,43.8901894211161,44.582334415973,45.02241112446197,45.31458969553324,44.619793613279036,44.16063077020812,null,43.83996832707437,44.27998185710843,44.582334415973,43.8901894211161,43.432141206894364,43.151831759612435,43.83996832707437,null,43.529159378549444,44.22937687763319,44.65050192265319,44.98561537537899,44.27998185710843,43.83996832707437,43.529159378549444,null,43.08811047479089,42.77037294798083,43.464066880102095,43.88735895435496,44.22937687763319,43.529159378549444,43.08811047479089,null,43.464066880102095,43.11660901132783,43.82108940492896,44.226007838353624,44.59979148875156,43.88735895435496,43.464066880102095,null,43.721107041218715,43.05466419811422,42.56352295918628,42.341569358746106,43.006469412688816,43.481589872981516,43.721107041218715,null,43.481589872981516,43.006469412688816,42.75581643563223,43.432141206894364,43.8901894211161,44.16063077020812,43.481589872981516,null,43.151831759612435,43.432141206894364,42.75581643563223,42.281574850895694,42.021383660406364,42.693764653301635,43.151831759612435,null,5.628355421123078,6.027045454964403,5.890939779517946,5.231141967118472,4.838442387956941,4.966689593831178,5.628355421123078,null,5.096373741685653,4.434696860576858,4.0479690886610555,4.174860274453392,4.838442387956941,5.231141967118472,5.096373741685653,null,4.966689593831178,4.838442387956941,4.174860274453392,3.783771698351591,3.90440503956277,4.569649577869654,4.966689593831178,null,4.569649577869654,3.90440503956277,3.508899505036913,3.623437585709038,4.290104021823178,4.691539250099806,4.569649577869654,null,2.727039503655563,2.8402863279019983,3.508899505036913,3.90440503956277,3.783771698351591,3.1166232359700228,2.727039503655563,null,1.9447059412671732,2.056527328800811,2.727039503655563,3.1166232359700228,2.9973753446742855,2.3283713556250296,1.9447059412671732,null,2.056527328800811,1.6683539901026805,1.774424684526759,2.4462116497866084,2.8402863279019983,2.727039503655563,2.056527328800811,null],lon:[1.6481877673878225,1.2209931710479323,1.3049545071015063,2.5819975723858057,3.027471759211076,2.9571255906834484,1.6481877673878225,null,.5745008950008981,.98221017492516,.8881772058853736,-.38901436162331554,-.779215982936662,-.6709425299200852,.5745008950008981,null,2.5819975723858057,1.3049545071015063,.8881772058853736,.98221017492516,2.2285063959516034,2.6625067849086115,2.5819975723858057,null,3.907200721549631,4.3694403795546535,4.3016251063795075,3.027471759211076,2.5819975723858057,2.6625067849086115,3.907200721549631,null,3.907200721549631,3.984921055304731,5.1982485735089545,5.675761976121988,5.609921982693346,4.3694403795546535,3.907200721549631,null,-2.2965881925384126,-2.4196994299605024,-3.6897166916597373,-4.03292166084515,-3.8944979836760822,-2.6574312569915826,-2.2965881925384126,null,-.6709425299200852,-.779215982936662,-2.0539992995630705,-2.4196994299605024,-2.2965881925384126,-1.0542819195330417,-.6709425299200852,null,-.9364914102211516,.2784746955405353,.6782974707685954,.5745008950008981,-.6709425299200852,-1.0542819195330417,-.9364914102211516,null,2.318911371121451,2.2285063959516034,.98221017492516,.5745008950008981,.6782974707685954,1.8949662562623932,2.318911371121451,null,3.5350823772212303,3.984921055304731,3.907200721549631,2.6625067849086115,2.2285063959516034,2.318911371121451,3.5350823772212303,null,5.273714053585451,5.1982485735089545,3.984921055304731,3.5350823772212303,3.622486665373304,4.809404849367125,5.273714053585451,null,6.8837714957055,5.675761976121988,5.1982485735089545,5.273714053585451,6.4567408108649245,6.948071093287058,6.8837714957055,null,6.948071093287058,6.4567408108649245,6.530375593871025,7.684227053846692,8.187961892397228,8.124868961561754,6.948071093287058,null,-1.0542819195330417,-2.2965881925384126,-2.6574312569915826,-2.5251536041941325,-1.3139329272530462,-.9364914102211516,-1.0542819195330417,null,.3917343342226599,.2784746955405353,-.9364914102211516,-1.3139329272530462,-1.1869444575464598,-.0012388916551973606,.3917343342226599,null,1.5798628490804443,1.9949989823874634,1.8949662562623932,.6782974707685954,.2784746955405353,.3917343342226599,1.5798628490804443,null,3.5350823772212303,2.318911371121451,1.8949662562623932,1.9949989823874634,3.1835769276287933,3.622486665373304,3.5350823772212303,null,3.622486665373304,3.1835769276287933,3.280437311070279,4.441703005094838,4.894319082537873,4.809404849367125,3.622486665373304,null,4.809404849367125,4.894319082537873,6.052935380697061,6.530375593871025,6.4567408108649245,5.273714053585451,4.809404849367125,null,-.0012388916551973606,-1.1869444575464598,-1.559333491357632,-1.4234526985056326,-.265843849692441,.12119175798147219,-.0012388916551973606,null,.12119175798147219,1.2818326109805702,1.6892570476253108,1.5798628490804443,.3917343342226599,-.0012388916551973606,.12119175798147219,null,1.6892570476253108,2.8511589825884682,3.280437311070279,3.1835769276287933,1.9949989823874634,1.5798628490804443,1.6892570476253108,null,4.53587721827223,4.441703005094838,3.280437311070279,2.8511589825884682,2.957244052659355,4.093618064858126,4.53587721827223,null,5.670683187655291,6.135770310014659,6.052935380697061,4.894319082537873,4.441703005094838,4.53587721827223,5.670683187655291,null,7.267093721890966,6.135770310014659,5.670683187655291,5.762566669035814,6.871821241496993,7.348175145030068,7.267093721890966,null,-1.4234526985056326,-1.7915317275537093,-1.6470511409727089,-.5164265601491487,-.13452514475015187,-.265843849692441,-1.4234526985056326,null,.9996448565930638,1.4003255369184155,1.2818326109805702,.12119175798147219,-.265843849692441,-.13452514475015187,.9996448565930638,null,1.2818326109805702,1.4003255369184155,2.536451193471495,2.957244052659355,2.8511589825884682,1.6892570476253108,1.2818326109805702,null,4.093618064858126,2.957244052659355,2.536451193471495,2.651528451037075,3.763769316347095,4.196855219600547,4.093618064858126,null,4.53587721827223,4.093618064858126,4.196855219600547,5.3084692520064065,5.762566669035814,5.670683187655291,4.53587721827223,null,6.496912530269895,6.961731753841522,6.871821241496993,5.762566669035814,5.3084692520064065,5.409237323243189,6.496912530269895,null,-.5164265601491487,-1.6470511409727089,-2.0114733025615052,-1.8586728162440884,-.7539695180955466,-.37649335497176306,-.5164265601491487,null,1.1269785874461098,.9996448565930638,-.13452514475015187,-.5164265601491487,-.37649335497176306,.7321863612321591,1.1269785874461098,null,1.1269785874461098,2.238207203932807,2.651528451037075,2.536451193471495,1.4003255369184155,.9996448565930638,1.1269785874461098,null,3.8758670924786465,3.763769316347095,2.651528451037075,2.238207203932807,2.3620449312561997,3.450904173341994,3.8758670924786465,null,4.964918268842381,5.409237323243189,5.3084692520064065,4.196855219600547,3.763769316347095,3.8758670924786465,4.964918268842381,null,5.074397979782408,6.141005005311512,6.595519407151364,6.496912530269895,5.409237323243189,4.964918268842381,5.074397979782408,null,6.595519407151364,7.660116199473526,8.134572644280114,8.046383422552427,6.961731753841522,6.496912530269895,6.595519407151364,null,-.37649335497176306,-.7539695180955466,-.6056858835909793,.47844801422382854,.8681086926471611,.7321863612321591,-.37649335497176306,null,.7321863612321591,.8681086926471611,1.9552968641966564,2.3620449312561997,2.238207203932807,1.1269785874461098,.7321863612321591,null,3.450904173341994,2.3620449312561997,1.9552968641966564,2.0876655338552723,3.1538841143168175,3.5716573174308897,3.450904173341994,null,-52.79779926608698,-53.164327547734594,-53.86308716531014,-54.02326130683637,-53.66122345050275,-52.96573050426695,-52.79779926608698,null,-54.722082735622635,-54.880522190171746,-54.523203093283826,-53.82739616369298,-53.66122345050275,-54.02326130683637,-54.722082735622635,null,-52.96573050426695,-53.66122345050275,-53.82739616369298,-53.46989593682573,-52.777555750877625,-52.60368086148081,-52.96573050426695,null,-52.60368086148081,-52.777555750877625,-52.41985736423746,-51.73106560897895,-51.54952939865659,-51.911610216330374,-52.60368086148081,null,-53.2889406602168,-52.59962703067153,-52.41985736423746,-52.777555750877625,-53.46989593682573,-53.64202367366148,-53.2889406602168,null,-54.157103634708456,-53.46697806405961,-53.2889406602168,-53.64202367366148,-54.3349278618435,-54.50534306583836,-54.157103634708456,null,-53.46697806405961,-53.118209053071865,-52.43178414418414,-52.24617000319843,-52.59962703067153,-53.2889406602168,-53.46697806405961,null],marker:{color:"rgb(92,97,102)",size:1}},{textfont:{size:10},mode:"text",showlegend:!1,type:"scattergeo",name:"Cell Number",lat:[51.040552849443756,49.48408697934639,49.89963225770053,50.29380216813867,49.536474810865464,48.591656531042375,49.04786170336731,48.336313330776576,48.757221666991974,49.15749425019322,48.40495300366802,48.76923932332709,47.99272571349133,47.89543256245911,47.18746432640766,47.61344242006117,48.0194811798336,47.27151159110315,47.64264794366311,46.037624985186795,46.46840327439469,46.87989901266934,46.13630063293223,46.513924949892356,45.747300850065045,44.886871752785915,45.322201982252686,45.73887000651951,44.999455312506896,45.38323359126643,44.62125434684014,43.73527355221173,44.174926640923545,44.5965043136731,43.86109771859788,44.25072129945529,43.49320257868042,43.85089090344587,43.02665685091586,43.45290143308913,42.72133838078778,5.431137304529584,4.6379551679550515,4.37367644893588,4.0987115871758935,3.3142155147513104,2.5291569734172628,2.2528560041286605],text:["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48"],lon:[2.1221694059324996,.0999179244925917,1.7735511762726635,3.4737254651408724,4.789581585180428,-3.165906596868219,-1.546685381647643,-.1893534963254259,1.4451574106816203,3.1049837113139,4.40275076822071,6.071372952909256,7.320692029029367,-1.7981338644673677,-.4622672090879485,1.1354035918568564,2.757231860378846,4.037527049668398,5.668342744440131,-.7200670041973137,.8428677721633031,2.4288659000119615,3.692300465650926,5.287405109991031,6.5081994261423235,-.9638718146324073,.5662706517743208,2.118442321328322,3.3656181112673242,4.926955506221755,6.134055719749452,-1.1946907294588567,.3044584822201469,1.8246589938842783,3.0561659573713547,4.585541946029603,5.779341444197468,7.314798581816773,.0563883457729327,1.5463386723392125,2.762753092174958,-53.41183646735349,-54.27219481326148,-53.21684326032635,-52.16482894620252,-53.032242806723644,-53.8984584698178,-52.85787284099258],marker:{size:5}}],layout:{template:{data:{scatterpolargl:[{type:"scatterpolargl",marker:{colorbar:{ticks:"",outlinewidth:0}}}],carpet:[{baxis:{gridcolor:"white",endlinecolor:"#2a3f5f",minorgridcolor:"white",startlinecolor:"#2a3f5f",linecolor:"white"},type:"carpet",aaxis:{gridcolor:"white",endlinecolor:"#2a3f5f",minorgridcolor:"white",startlinecolor:"#2a3f5f",linecolor:"white"}}],scatterpolar:[{type:"scatterpolar",marker:{colorbar:{ticks:"",outlinewidth:0}}}],parcoords:[{line:{colorbar:{ticks:"",outlinewidth:0}},type:"parcoords"}],scatter:[{type:"scatter",marker:{colorbar:{ticks:"",outlinewidth:0}}}],histogram2dcontour:[{colorbar:{ticks:"",outlinewidth:0},type:"histogram2dcontour",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],contour:[{colorbar:{ticks:"",outlinewidth:0},type:"contour",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],scattercarpet:[{type:"scattercarpet",marker:{colorbar:{ticks:"",outlinewidth:0}}}],mesh3d:[{colorbar:{ticks:"",outlinewidth:0},type:"mesh3d"}],surface:[{colorbar:{ticks:"",outlinewidth:0},type:"surface",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],scattermapbox:[{type:"scattermapbox",marker:{colorbar:{ticks:"",outlinewidth:0}}}],scattergeo:[{type:"scattergeo",marker:{colorbar:{ticks:"",outlinewidth:0}}}],histogram:[{type:"histogram",marker:{colorbar:{ticks:"",outlinewidth:0}}}],pie:[{type:"pie",automargin:!0}],choropleth:[{colorbar:{ticks:"",outlinewidth:0},type:"choropleth"}],heatmapgl:[{colorbar:{ticks:"",outlinewidth:0},type:"heatmapgl",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],bar:[{type:"bar",error_y:{color:"#2a3f5f"},error_x:{color:"#2a3f5f"},marker:{line:{color:"#E5ECF6",width:.5}}}],heatmap:[{colorbar:{ticks:"",outlinewidth:0},type:"heatmap",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],contourcarpet:[{colorbar:{ticks:"",outlinewidth:0},type:"contourcarpet"}],table:[{type:"table",header:{line:{color:"white"},fill:{color:"#C8D4E3"}},cells:{line:{color:"white"},fill:{color:"#EBF0F8"}}}],scatter3d:[{line:{colorbar:{ticks:"",outlinewidth:0}},type:"scatter3d",marker:{colorbar:{ticks:"",outlinewidth:0}}}],scattergl:[{type:"scattergl",marker:{colorbar:{ticks:"",outlinewidth:0}}}],histogram2d:[{colorbar:{ticks:"",outlinewidth:0},type:"histogram2d",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],scatterternary:[{type:"scatterternary",marker:{colorbar:{ticks:"",outlinewidth:0}}}],barpolar:[{type:"barpolar",marker:{line:{color:"#E5ECF6",width:.5}}}]},layout:{xaxis:{gridcolor:"white",zerolinewidth:2,title:{standoff:15},ticks:"",zerolinecolor:"white",automargin:!0,linecolor:"white"},hovermode:"closest",paper_bgcolor:"white",geo:{showlakes:!0,showland:!0,landcolor:"#E5ECF6",bgcolor:"white",subunitcolor:"white",lakecolor:"white"},colorscale:{sequential:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]],diverging:[[0,"#8e0152"],[.1,"#c51b7d"],[.2,"#de77ae"],[.3,"#f1b6da"],[.4,"#fde0ef"],[.5,"#f7f7f7"],[.6,"#e6f5d0"],[.7,"#b8e186"],[.8,"#7fbc41"],[.9,"#4d9221"],[1,"#276419"]],sequentialminus:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]},yaxis:{gridcolor:"white",zerolinewidth:2,title:{standoff:15},ticks:"",zerolinecolor:"white",automargin:!0,linecolor:"white"},shapedefaults:{line:{color:"#2a3f5f"}},font:{color:"#2a3f5f"},annotationdefaults:{arrowhead:0,arrowwidth:1,arrowcolor:"#2a3f5f"},plot_bgcolor:"#E5ECF6",title:{x:.05},coloraxis:{colorbar:{ticks:"",outlinewidth:0}},hoverlabel:{align:"left"},mapbox:{style:"light"},polar:{angularaxis:{gridcolor:"white",ticks:"",linecolor:"white"},bgcolor:"#E5ECF6",radialaxis:{gridcolor:"white",ticks:"",linecolor:"white"}},autotypenumbers:"strict",ternary:{aaxis:{gridcolor:"white",ticks:"",linecolor:"white"},bgcolor:"#E5ECF6",caxis:{gridcolor:"white",ticks:"",linecolor:"white"},baxis:{gridcolor:"white",ticks:"",linecolor:"white"}},scene:{xaxis:{gridcolor:"white",gridwidth:2,backgroundcolor:"#E5ECF6",ticks:"",showbackground:!0,zerolinecolor:"white",linecolor:"white"},zaxis:{gridcolor:"white",gridwidth:2,backgroundcolor:"#E5ECF6",ticks:"",showbackground:!0,zerolinecolor:"white",linecolor:"white"},yaxis:{gridcolor:"white",gridwidth:2,backgroundcolor:"#E5ECF6",ticks:"",showbackground:!0,zerolinecolor:"white",linecolor:"white"}},colorway:["#636efa","#EF553B","#00cc96","#ab63fa","#FFA15A","#19d3f3","#FF6692","#B6E880","#FF97FF","#FECB52"]}},geo:{showland:!0,showocean:!0,fitbounds:"locations",projection:{type:"natural earth"},landcolor:"rgb(217, 217, 217)",oceancolor:"rgb(255, 255, 255)",lonaxis:{showgrid:!0,gridcolor:"rgb(102, 102, 102)"},showlakes:!0,showcountries:!0,lakecolor:"rgb(255, 255, 255)",lataxis:{showgrid:!0,gridcolor:"rgb(102, 102, 102)"}},margin:{l:50,b:50,r:50,t:60},title:"75km Hexagonal Cells Over France"},config:{showLink:!1,editable:!1,responsive:!0,staticPlot:!1,scrollZoom:!0}}),l[1]||(l[1]=i(`<p>This example shows how to:</p><ol><li>Define a geographical region using a country name</li><li>Create a hexagonal tessellation with 75km cell radius</li><li>Visualize the resulting cell layout</li></ol><h2 id="Getting-Started" tabindex="-1">Getting Started <a class="header-anchor" href="#Getting-Started" aria-label="Permalink to &quot;Getting Started {#Getting-Started}&quot;">​</a></h2><p>To install GeoGrids.jl, use Julia&#39;s package manager:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Pkg</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Pkg</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;GeoGrids&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Then import the package:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> GeoGrids</span></span></code></pre></div><p>For more detailed information, see the documentation for each component.</p>`,8))])}const f=e(r,[["render",h]]);export{E as __pageData,f as default};
