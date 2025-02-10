import{_ as e,c as s,a7 as l,G as t,B as n,o}from"./chunks/framework.PIQApXt7.js";const E=JSON.parse('{"title":"GeoGrids.jl","description":"","frontmatter":{},"headers":[],"relativePath":"index.md","filePath":"index.md","lastUpdated":null}'),r={name:"index.md"};function h(c,i,p,d,k,u){const a=n("VuePlotly");return o(),s("div",null,[i[0]||(i[0]=l(`<h1 id="geogrids-jl" tabindex="-1">GeoGrids.jl <a class="header-anchor" href="#geogrids-jl" aria-label="Permalink to &quot;GeoGrids.jl&quot;">​</a></h1><p><strong>GeoGrids.jl</strong> is a Julia package for generating and manipulating geographical grids, particularly useful for system-level simulations and geospatial analysis. The package provides tools for creating various types of grids, defining geographical regions, and performing spatial operations.</p><h2 id="features" tabindex="-1">Features <a class="header-anchor" href="#features" aria-label="Permalink to &quot;Features&quot;">​</a></h2><ul><li><strong>Grid Generation</strong>: Create uniform point distributions using icosahedral, rectangular, or vector grid patterns</li><li><strong>Region Definition</strong>: Define areas of interest using latitude belts, country boundaries, or custom polygons</li><li><strong>Tessellation</strong>: Generate cell layouts with hexagonal or icosahedral patterns</li><li><strong>Filtering</strong>: Efficiently filter and group points based on geographical regions</li></ul><h2 id="Quick-Example" tabindex="-1">Quick Example <a class="header-anchor" href="#Quick-Example" aria-label="Permalink to &quot;Quick Example {#Quick-Example}&quot;">​</a></h2><p>Here&#39;s a simple example that demonstrates some key features of GeoGrids.jl:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> GeoGrids</span></span>
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
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div>`,7)),t(a,{data:[{showlegend:!1,mode:"lines",type:"scattergeo",name:"Cell Contour",lat:[49.15745077150639,49.70966516634168,49.75135970763122,49.15614019976103,48.58160359373514,48.54348661653584,49.15745077150639,null,49.15745077150639,49.0779818292749,49.71458773429199,50.24129293687956,50.3282980612787,49.70966516634168,49.15745077150639,null,49.71458773429199,49.59054267696677,50.252131652288384,50.750151319048385,50.88606139296167,50.24129293687956,49.71458773429199,null,50.08035581388004,50.252131652288384,49.59054267696677,49.08118638307279,48.924146588838084,49.59880876001956,50.08035581388004,null,49.39545508132651,49.59880876001956,48.924146588838084,48.429077501905404,48.242849565619906,48.92712294499052,49.39545508132651,null,48.58160359187351,47.98788718077318,47.98788717780778,48.58160359373514,49.15614019976103,49.156140202961616,48.58160359187351,null,47.41202302592392,47.377102163603894,47.986946100209714,48.54348661653584,48.58160359373514,47.98788717780778,47.41202302592392,null,48.54361026633701,49.0779818292749,49.15745077150639,48.54348661653584,47.986946100209714,47.914201819133204,48.54361026633701,null,48.430142605797705,49.08118638307279,49.59054267696677,49.71458773429199,49.0779818292749,48.54361026633701,48.430142605797705,null,48.429077501905404,48.924146588838084,49.08118638307279,48.430142605797705,47.91077416295463,47.76690322802751,48.429077501905404,null,48.429077501905404,47.76690322802751,47.25986387161277,47.088979377722445,47.759223217729996,48.242849565619906,48.429077501905404,null,47.759223217729996,47.547355678896544,48.238075313323826,48.69617819633786,48.92712294499052,48.242849565619906,47.759223217729996,null,47.98788718077318,48.58160359187351,48.5434866208197,47.986946099596615,47.377102167575195,47.41202302419302,47.98788718077318,null,47.41202302419302,46.819634156560184,46.819634153805744,47.41202302592392,47.98788717780778,47.98788718077318,47.41202302419302,null,46.210537609490764,46.81673616096536,47.377102163603894,47.41202302592392,46.819634153805744,46.24259456953469,46.210537609490764,null,47.914201819133204,47.986946100209714,47.377102163603894,46.81673616096536,46.75001074263674,47.37305629579058,47.914201819133204,null,47.37305629579058,47.26904728169311,47.91077416295463,48.430142605797705,48.54361026633701,47.914201819133204,47.37305629579058,null,47.76690322802751,47.91077416295463,47.26904728169311,46.740814060679845,46.60874596945494,47.25986387161277,47.76690322802751,null,47.25986387161277,46.60874596945494,46.09108499402822,45.933985151575364,46.59178067903083,47.088979377722445,47.25986387161277,null,45.64678061540245,46.210537609490764,46.24259456953469,45.65138112773776,45.07329838687209,45.04381492617825,45.64678061540245,null,45.64678061540245,45.585457900085906,46.20286487103756,46.75001074263674,46.81673616096536,46.210537609490764,45.64678061540245,null,46.740814060679845,47.26904728169311,47.37305629579058,46.75001074263674,46.20286487103756,46.10733878949436,46.740814060679845,null,45.44977806460365,46.09108499402822,46.60874596945494,46.740814060679845,46.10733878949436,45.57123824745043,45.44977806460365,null,44.77798839980004,45.424715748577846,45.933985151575364,46.09108499402822,45.44977806460365,44.92267148381837,44.77798839980004,null,45.90740126207477,46.39705006133447,46.59178067903083,45.933985151575364,45.424715748577846,45.24541906228942,45.90740126207477,null,45.07329838687209,44.483128099589855,43.904117612972286,43.87695290700447,44.47704533902026,45.04381492617825,45.07329838687209,null,45.04381492617825,44.47704533902026,44.42058550558622,45.032984674799586,45.585457900085906,45.64678061540245,45.04381492617825,null,46.10733878949436,46.20286487103756,45.585457900085906,45.032984674799586,44.9450875061871,45.57123824745043,46.10733878949436,null,44.92267148381837,45.44977806460365,45.57123824745043,44.9450875061871,44.4019896682006,44.290088559398995,44.92267148381837,null,44.77798839980004,44.92267148381837,44.290088559398995,43.75456507239895,43.621094535648204,44.25796193995934,44.77798839980004,null,44.25796193995934,44.09259979546164,44.74253025383716,45.24541906228942,45.424715748577846,44.77798839980004,44.25796193995934,null,42.735037851843664,42.70996769400666,43.30750134816924,43.87695290700447,43.904117612972286,43.314875069351324,42.735037851843664,null,43.86337233366656,44.42058550558622,44.47704533902026,43.87695290700447,43.30750134816924,43.25542986061916,43.86337233366656,null,44.42058550558622,43.86337233366656,43.782354031699086,44.4019896682006,44.9450875061871,45.032984674799586,44.42058550558622,null,44.290088559398995,44.4019896682006,43.782354031699086,43.23302016648584,43.129754563156716,43.75456507239895,44.290088559398995,null,43.621094535648204,43.0914635805731,42.93871190522795,43.57788594458755,44.09259979546164,44.25796193995934,43.621094535648204,null,43.25542986061916,42.69399105453951,42.61919076178737,43.23302016648584,43.782354031699086,43.86337233366656,43.25542986061916,null,41.536080989736575,42.174620350360726,42.683408247709636,42.88319628886054,42.2435217019861,41.72114101482225,41.536080989736575,null],lon:[.327671074076886,.13357111940605115,-1.2083394861604893,-1.4372970168606387,-1.2234583090963183,.07829458214277596,.327671074076886,null,.327671074076886,1.646209857140099,1.9134716401089762,1.739078480539272,.3796369691188558,.13357111940605115,.327671074076886,null,1.9134716401089762,3.2468988107154084,3.5341639663945315,3.3792673348427553,2.0044325947997357,1.739078480539272,1.9134716401089762,null,4.880276573885502,3.5341639663945315,3.2468988107154084,3.4099604083840966,4.7165436026238465,5.024979976292677,4.880276573885502,null,6.341770228732807,5.024979976292677,4.7165436026238465,4.869825918550824,6.1490255599850725,6.477769945296528,6.341770228732807,null,-2.9737109916866147,-2.7402670310586297,-1.456902272513191,-1.2234583090963183,-1.4372970168606387,-2.7598722811904044,-2.9737109916866147,null,-1.2376062511570476,.02604932307352037,.27881437425157884,.07829458214277596,-1.2234583090963183,-1.456902272513191,-1.2376062511570476,null,1.8279324233972516,1.646209857140099,.327671074076886,.07829458214277596,.27881437425157884,1.558555892490296,1.8279324233972516,null,3.122073715501794,3.4099604083840966,3.2468988107154084,1.9134716401089762,1.646209857140099,1.8279324233972516,3.122073715501794,null,4.869825918550824,4.7165436026238465,3.4099604083840966,3.122073715501794,3.2930125934729575,4.562015829768397,4.869825918550824,null,4.869825918550824,4.562015829768397,4.7235741559573245,5.966956157642716,6.293879237240016,6.1490255599850725,4.869825918550824,null,6.293879237240016,7.545413664126441,7.893503301976104,7.764927907172021,6.477769945296528,6.1490255599850725,6.293879237240016,null,-2.7402670310586297,-2.9737109916866147,-4.275463883170929,-4.475983677828155,-4.223218629480019,-2.95956305502803,-2.7402670310586297,null,-2.95956305502803,-2.7216575674848063,-1.4755117413635592,-1.2376062511570476,-1.456902272513191,-2.7402670310586297,-2.95956305502803,null,-.023400675435161555,.23281480457926007,.02604932307352037,-1.2376062511570476,-1.4755117413635592,-1.2508627751788874,-.023400675435161555,null,1.558555892490296,.27881437425157884,.02604932307352037,.23281480457926007,1.4757043530869183,1.747371666415349,1.558555892490296,null,1.747371666415349,3.0041890336102117,3.2930125934729575,3.122073715501794,1.8279324233972516,1.558555892490296,1.747371666415349,null,4.562015829768397,3.2930125934729575,3.0041890336102117,3.182738151821071,4.415971524324872,4.7235741559573245,4.562015829768397,null,4.7235741559573245,4.415971524324872,4.585523404642859,5.794741922492053,6.120359410140397,5.966956157642716,4.7235741559573245,null,.18944699610864468,-.023400675435161555,-1.2508627751788874,-1.4932002631040686,-1.2632990365081604,-.07026685987895342,.18944699610864468,null,.18944699610864468,1.397286279113057,1.6713935832349787,1.4757043530869183,.23281480457926007,-.023400675435161555,.18944699610864468,null,3.182738151821071,3.0041890336102117,1.747371666415349,1.4757043530869183,1.6713935832349787,2.8927054823577096,3.182738151821071,null,4.27776374247559,4.585523404642859,4.415971524324872,3.182738151821071,2.8927054823577096,3.07861611973414,4.27776374247559,null,5.631646008166239,5.956409078410121,5.794741922492053,4.585523404642859,4.27776374247559,4.455045074299372,5.631646008166239,null,7.484176623536479,7.337866698735628,6.120359410140397,5.794741922492053,5.956409078410121,7.141386920490257,7.484176623536479,null,-1.2632990365081604,-1.51003495989118,-1.2749789380698187,-.11473920171273777,.14850884627517913,-.07026685987895342,-1.2632990365081604,null,-.07026685987895342,.14850884627517913,1.3229704882426945,1.599643711282475,1.397286279113057,.18944699610864468,-.07026685987895342,null,2.8927054823577096,1.6713935832349787,1.397286279113057,1.599643711282475,2.7871393690798847,3.07861611973414,2.8927054823577096,null,4.455045074299372,4.27776374247559,3.07861611973414,2.7871393690798847,2.980179095116976,4.146810971118958,4.455045074299372,null,5.631646008166239,4.455045074299372,4.146810971118958,4.331574147609766,5.477004632969822,5.801308438810754,5.631646008166239,null,5.801308438810754,6.9551636944281485,7.296136884328298,7.141386920490257,5.956409078410121,5.631646008166239,5.801308438810754,null,-1.285960028492838,-.15698883599320124,.10981860546270972,-.11473920171273777,-1.2749789380698187,-1.5260761983050486,-1.285960028492838,null,1.5318036807494002,1.3229704882426945,.14850884627517913,-.11473920171273777,.10981860546270972,1.2524588969096877,1.5318036807494002,null,1.3229704882426945,1.5318036807494002,2.687055664776123,2.980179095116976,2.7871393690798847,1.599643711282475,1.3229704882426945,null,4.146810971118958,2.980179095116976,2.687055664776123,2.887006566519225,4.022589139407302,4.331574147609766,4.146810971118958,null,5.477004632969822,5.654409230652975,6.7784651430804645,7.1180889969281536,6.9551636944281485,5.801308438810754,5.477004632969822,null,1.2524588969096877,1.4675867600601387,2.592062088003017,2.887006566519225,2.687055664776123,1.5318036807494002,1.2524588969096877,null,9.298319520228715,9.666149226761283,9.514514191689631,8.40611459159622,8.051969610715087,8.216962806805046,9.298319520228715,null],marker:{color:"rgb(92,97,102)",size:1}},{textfont:{size:10},mode:"text",showlegend:!1,type:"scattergeo",name:"Cell Number",lat:[49.146518155521356,49.70120960794479,50.2352226324727,49.58427394425476,48.91629346362636,48.57201369083252,47.978545005957464,48.53410658062155,49.06962663489276,48.420601605727164,47.754980431747114,48.232141975564375,47.978545007125696,47.403760667748436,46.81055696723468,47.36694156675136,47.90388560463047,47.25668339002878,46.593301210982176,45.64255522071326,46.19971954293309,46.73801131364179,46.092538936020105,45.43128456943015,45.914512452610744,44.47454082672887,45.032444970067765,45.57201430122647,44.92818586031227,44.26895636403949,44.754982871482184,43.30651473973463,43.86512185857358,44.40590403140075,43.76364001114317,43.59502462840835,43.23968902679391,42.20572996902121],text:["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38"],lon:[-.5550201164625345,1.0230771336876234,2.6359124017816864,4.135086482282084,5.596201966188904,-2.0985846504047894,-.5892198529954391,.952735294488115,2.5274802162637577,3.995223314437409,5.427136151672378,7.020246517684692,-3.6079494506034915,-2.0985846531042083,-.6214969626156917,.8863901938395914,2.4252704279620216,3.863266202680878,5.267480498434482,-.6520010289549197,.8237270409349937,2.32878748721625,3.738596907007473,5.116513052418084,6.638734274048618,-.680866224001189,.7644638199624109,2.2375879125890528,3.6206610208899894,4.973585042965697,6.463288114494446,-.7082132318838489,.7083471567325621,2.1512736677035322,3.508959999811336,6.297051334214897,2.0694865245445944,8.858582079292997],marker:{size:5}}],layout:{template:{data:{scatterpolargl:[{type:"scatterpolargl",marker:{colorbar:{ticks:"",outlinewidth:0}}}],carpet:[{baxis:{gridcolor:"white",endlinecolor:"#2a3f5f",minorgridcolor:"white",startlinecolor:"#2a3f5f",linecolor:"white"},type:"carpet",aaxis:{gridcolor:"white",endlinecolor:"#2a3f5f",minorgridcolor:"white",startlinecolor:"#2a3f5f",linecolor:"white"}}],scatterpolar:[{type:"scatterpolar",marker:{colorbar:{ticks:"",outlinewidth:0}}}],parcoords:[{line:{colorbar:{ticks:"",outlinewidth:0}},type:"parcoords"}],scatter:[{type:"scatter",marker:{colorbar:{ticks:"",outlinewidth:0}}}],histogram2dcontour:[{colorbar:{ticks:"",outlinewidth:0},type:"histogram2dcontour",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],contour:[{colorbar:{ticks:"",outlinewidth:0},type:"contour",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],scattercarpet:[{type:"scattercarpet",marker:{colorbar:{ticks:"",outlinewidth:0}}}],mesh3d:[{colorbar:{ticks:"",outlinewidth:0},type:"mesh3d"}],surface:[{colorbar:{ticks:"",outlinewidth:0},type:"surface",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],scattermapbox:[{type:"scattermapbox",marker:{colorbar:{ticks:"",outlinewidth:0}}}],scattergeo:[{type:"scattergeo",marker:{colorbar:{ticks:"",outlinewidth:0}}}],histogram:[{type:"histogram",marker:{colorbar:{ticks:"",outlinewidth:0}}}],pie:[{type:"pie",automargin:!0}],choropleth:[{colorbar:{ticks:"",outlinewidth:0},type:"choropleth"}],heatmapgl:[{colorbar:{ticks:"",outlinewidth:0},type:"heatmapgl",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],bar:[{type:"bar",error_y:{color:"#2a3f5f"},error_x:{color:"#2a3f5f"},marker:{line:{color:"#E5ECF6",width:.5}}}],heatmap:[{colorbar:{ticks:"",outlinewidth:0},type:"heatmap",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],contourcarpet:[{colorbar:{ticks:"",outlinewidth:0},type:"contourcarpet"}],table:[{type:"table",header:{line:{color:"white"},fill:{color:"#C8D4E3"}},cells:{line:{color:"white"},fill:{color:"#EBF0F8"}}}],scatter3d:[{line:{colorbar:{ticks:"",outlinewidth:0}},type:"scatter3d",marker:{colorbar:{ticks:"",outlinewidth:0}}}],scattergl:[{type:"scattergl",marker:{colorbar:{ticks:"",outlinewidth:0}}}],histogram2d:[{colorbar:{ticks:"",outlinewidth:0},type:"histogram2d",colorscale:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]}],scatterternary:[{type:"scatterternary",marker:{colorbar:{ticks:"",outlinewidth:0}}}],barpolar:[{type:"barpolar",marker:{line:{color:"#E5ECF6",width:.5}}}]},layout:{xaxis:{gridcolor:"white",zerolinewidth:2,title:{standoff:15},ticks:"",zerolinecolor:"white",automargin:!0,linecolor:"white"},hovermode:"closest",paper_bgcolor:"white",geo:{showlakes:!0,showland:!0,landcolor:"#E5ECF6",bgcolor:"white",subunitcolor:"white",lakecolor:"white"},colorscale:{sequential:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]],diverging:[[0,"#8e0152"],[.1,"#c51b7d"],[.2,"#de77ae"],[.3,"#f1b6da"],[.4,"#fde0ef"],[.5,"#f7f7f7"],[.6,"#e6f5d0"],[.7,"#b8e186"],[.8,"#7fbc41"],[.9,"#4d9221"],[1,"#276419"]],sequentialminus:[[0,"#0d0887"],[.1111111111111111,"#46039f"],[.2222222222222222,"#7201a8"],[.3333333333333333,"#9c179e"],[.4444444444444444,"#bd3786"],[.5555555555555556,"#d8576b"],[.6666666666666666,"#ed7953"],[.7777777777777778,"#fb9f3a"],[.8888888888888888,"#fdca26"],[1,"#f0f921"]]},yaxis:{gridcolor:"white",zerolinewidth:2,title:{standoff:15},ticks:"",zerolinecolor:"white",automargin:!0,linecolor:"white"},shapedefaults:{line:{color:"#2a3f5f"}},font:{color:"#2a3f5f"},annotationdefaults:{arrowhead:0,arrowwidth:1,arrowcolor:"#2a3f5f"},plot_bgcolor:"#E5ECF6",title:{x:.05},coloraxis:{colorbar:{ticks:"",outlinewidth:0}},hoverlabel:{align:"left"},mapbox:{style:"light"},polar:{angularaxis:{gridcolor:"white",ticks:"",linecolor:"white"},bgcolor:"#E5ECF6",radialaxis:{gridcolor:"white",ticks:"",linecolor:"white"}},autotypenumbers:"strict",ternary:{aaxis:{gridcolor:"white",ticks:"",linecolor:"white"},bgcolor:"#E5ECF6",caxis:{gridcolor:"white",ticks:"",linecolor:"white"},baxis:{gridcolor:"white",ticks:"",linecolor:"white"}},scene:{xaxis:{gridcolor:"white",gridwidth:2,backgroundcolor:"#E5ECF6",ticks:"",showbackground:!0,zerolinecolor:"white",linecolor:"white"},zaxis:{gridcolor:"white",gridwidth:2,backgroundcolor:"#E5ECF6",ticks:"",showbackground:!0,zerolinecolor:"white",linecolor:"white"},yaxis:{gridcolor:"white",gridwidth:2,backgroundcolor:"#E5ECF6",ticks:"",showbackground:!0,zerolinecolor:"white",linecolor:"white"}},colorway:["#636efa","#EF553B","#00cc96","#ab63fa","#FFA15A","#19d3f3","#FF6692","#B6E880","#FF97FF","#FECB52"]}},geo:{showland:!0,showocean:!0,fitbounds:"locations",projection:{type:"natural earth"},landcolor:"rgb(217, 217, 217)",oceancolor:"rgb(255, 255, 255)",lonaxis:{showgrid:!0,gridcolor:"rgb(102, 102, 102)"},showlakes:!0,showcountries:!0,lakecolor:"rgb(255, 255, 255)",lataxis:{showgrid:!0,gridcolor:"rgb(102, 102, 102)"}},margin:{l:50,b:50,r:50,t:60},title:"75km Hexagonal Cells Over France"},config:{showLink:!1,editable:!1,responsive:!0,staticPlot:!1,scrollZoom:!0}}),i[1]||(i[1]=l(`<p>This example shows how to:</p><ol><li>Define a geographical region using a country name</li><li>Create a hexagonal tessellation with 75km cell radius</li><li>Visualize the resulting cell layout</li></ol><h2 id="Getting-Started" tabindex="-1">Getting Started <a class="header-anchor" href="#Getting-Started" aria-label="Permalink to &quot;Getting Started {#Getting-Started}&quot;">​</a></h2><p>To install GeoGrids.jl, use Julia&#39;s package manager:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> Pkg</span></span>
<span class="line"><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">Pkg</span><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">.</span><span style="--shiki-light:#005CC5;--shiki-dark:#79B8FF;">add</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">(</span><span style="--shiki-light:#032F62;--shiki-dark:#9ECBFF;">&quot;GeoGrids&quot;</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;">)</span></span></code></pre></div><p>Then import the package:</p><div class="language-julia vp-adaptive-theme"><button title="Copy Code" class="copy"></button><span class="lang">julia</span><pre class="shiki shiki-themes github-light github-dark vp-code" tabindex="0"><code><span class="line"><span style="--shiki-light:#D73A49;--shiki-dark:#F97583;">using</span><span style="--shiki-light:#24292E;--shiki-dark:#E1E4E8;"> GeoGrids</span></span></code></pre></div><p>For more detailed information, see the documentation for each component.</p>`,8))])}const f=e(r,[["render",h]]);export{E as __pageData,f as default};
