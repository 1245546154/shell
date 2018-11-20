#!/bin/bash
u=`echo $LANG | cut -d "." -f2`
if [ $u = UTF-8 ]
then
whiptail --title "语言检测" --msgbox "语言正确 正在进入" 10 60
elif [ $u = utf-8 ]
then
whiptail --title "语言检测" --msgbox "语言正确 正在进入" 10 60
elif [ $u = utf8 ]
then
whiptail --title "语言检测" --msgbox "语言正确 正在进入" 10 60
elif [ $u = UTF8 ]
then
whiptail --title "语言检测" --msgbox "语言正确 正在进入" 10 60
else
whiptail --title "语言检测" --msgbox "语言错误 请调至UTF-8" 10 60
exit 0
fi
bjcpu=`cat /proc/cpuinfo  | awk -F ':' 'NR==5{print $2}'|awk -F ' ' '{print $3}'`
{
    for ((i = 1 ; i <= 100 ; i+=1)); do
	sleep 0.01
        echo $i
    done
} | whiptail --gauge "正在载入测试软件" 6 60 0
aOPTION=$(whiptail --title "请选择CPU开始测试" --menu "请选择CPU开始自动测试" 15 60 4 \
1 测试CPU   \
3>&1 1>&2 2>&3)
if [ $? -eq 1 ]
then
whiptail --title "退出" --msgbox "欢迎下次再来" 10 60
exit
fi
if [ $aOPTION = 1 ]
then
echo "
1	Intel Core i9-7900X	                                   			
2	Intel Xeon W-2145	                                   
3	Intel Core i7-6950X	                                   
4	Intel Core i7-8700K	                                   
5	Intel Core i7-8700	                                   
6	Intel Core i9-8950HK	                                   
7	Intel Xeon E-2186M	                                   
8	Intel Xeon E5-2680 v4	                                   
9	AMD Ryzen 7 1800X	                                   
10	AMD Ryzen 7 1700X	                                   
11	Intel Xeon E5-2697 v2	                                   
12	Intel Core i5-8600K	                                   
13	Intel Xeon E-2176M	                                   
14	Intel Core i7-8850H	                                   
15	Intel Core i7-7740X	                                   
16	Intel Core i7-7700K	                                   
17	Intel Core i7-8750H	                                   
18	Intel Core i5-8400	                                   
19	Intel Core i7-5960X	                                   
20	AMD Ryzen 7 1700	                                   
21	Intel Core i7-4960X	                                   
22	Intel Core i7-7700	                                   
23	Intel Core i7-6700K	                                   
24	Intel Xeon E5-2680	                                   
25	Intel Core i7-3960X	                                   
26	Intel Core i7-4790K	                                   
27	AMD Ryzen 5 1600	                                   
28	Intel Xeon E3-1280 v5	                                   
29	Intel Core i7-6700	                                   
30	Intel Core i7-8809G	                                   
31	Intel Xeon E3-1535M v6	                                   
32	Intel Core i5-8400H	                                   
33	Intel Core i7-8709G	                                   
34	Intel Core i7-8706G	                                   
35	Intel Core i7-8705G	                                   
36	Intel Core i7-7920HQ	                                   
37	Intel Core i7-4790	                                   
38	Intel Core i5-7600K	                                   
39	Intel Core i7-5775C	                                   
40	Intel Core i7-4770K	                                   
41	Intel Core i7-4790S	                                   
42	Intel Xeon E3-1505M v6	                                   
43	Intel Core i5-8300H	                                   
44	Intel Xeon E3-1575M v5	                                   
45	AMD Ryzen 5 1500X	                                   
46	Intel Core i7-4940MX	                                   
47	Intel Core i7-7820HQ	                                   
48	Intel Core i7-7820HK	                                   
49	Intel Core i7-6920HQ	                                   
50	Intel Xeon E3-1545M v5	                                   
51	Intel Core i7-5950HQ	                                   
52	Intel Core i7-4930MX	                                   
53	Intel Xeon E3-1535M v5	                                   
54	Intel Core i7-6970HQ	                                   
55	Intel Core i5-8305G	                                   
56	Intel Core i7-7700HQ	                                   
57	Intel Core i5-7500	                                   
58	Intel Xeon E3-1515M v5	                                   
59	AMD Ryzen 5 2400G	                                   
60	Intel Xeon E3-1505M v5	                                   
61	Intel Core i7-6870HQ	                                   
62	Intel Core i7-4980HQ	                                   
63	Intel Core i7-4910MQ	                                   
64	Intel Xeon E3-1231 v3	                                   
65	Intel Xeon E3-1230 v3	                                   
66	Intel Core i7-5850HQ	                                   
67	Intel Core i5-6600K	                                   
68	Intel Core i7-3770K	                                   
69	Intel Core i7-3940XM	                                   
70	Intel Core i7-5700HQ	                                   
71	Intel Core i7-5750HQ	                                   
72	Intel Core i7-6820HK	                                   
73	Intel Core i7-6820HQ	                                   
74	AMD Ryzen 5 1400	                                   
75	Intel Core i7-6770HQ	                                   
76	Intel Core i7-6700T	                                   
77	Intel Core i7-4900MQ	                                   
78	Intel Core i7-4960HQ	                                   
79	Intel Core i7-6700HQ	                                   
80	Intel Core i7-4810MQ	                                   
81	Intel Core i7-4870HQ	                                   
82	AMD Ryzen 3 1300X	                                   
83	Intel Core i7-8650U	                                   
84	Intel Core i7-3920XM	                                   
85	Intel Core i7-4800MQ	                                   
86	Intel Core i7-4950HQ	                                   
87	Intel Core i7-2700K	                                   
88	Intel Core i7-4860HQ	                                   
89	Intel Core i7-4720HQ	                                   
90	Intel Core i7-3840QM	                                   
91	Intel Core i7-4850HQ	                                   
92	Intel Core i7-4710HQ	                                   
93	Intel Core i7-4710MQ	                                   
94	Intel Core i7-4770HQ	                                   
95	Intel Core i7-3820QM	                                   
96	Intel Core i7-2600K	                                   
97	Intel Core i5-7440HQ	                                   
98	Intel Core i7-3740QM	                                   
99	Intel Core i7-3720QM	                                   
100	Intel Core i7-4700HQ	                                   
101	Intel Core i7-4700MQ	                                   
102	Intel Core i7-4760HQ	                                   
103	Intel Core i7-4722HQ	                                   
104	Intel Xeon E3-1226 v3	                                   
105	Intel Core i5-4590	                                   
106	Intel Core i7-2960XM	                                   
107	Intel Core i5-3570K	                                   
108	Intel Core i5-6500	                                   
109	Intel Core i7-7567U	                                   
110	Intel Core i7-7660U	                                   
111	Intel Core i7-7600U	                                   
112	Intel Core i7-4712HQ	                                   
113	Intel Core i7-4712MQ	                                   
114	Intel Core i7-4750HQ	                                   
115	Intel Core i7-3635QM	                                   
116	Intel Core i7-3630QM	                                   
117	Intel Core i5-3550	                                   
118	Intel Core i7-8550U	                                   
119	Intel Core i7-4702HQ	                                   
120	Intel Core i7-4702MQ	                                   
121	Intel Core i7-2860QM	                                   
122	Intel Core i7-2920XM	                                   
123	Intel Core i5-3470	                                   
124	Intel Core i7-3615QM	                                   
125	Intel Core i7-3610QM	                                   
126	AMD FX-8350	8MB + 8M                                   
127	Intel Core i5-2500K	                                   
128	Intel Core i5-6600T	                                   
129	Intel Core i5-7300HQ	                                   
130	Intel Core i5-6440HQ	                                   
131	Intel Core i5-4460	                                   
132	Intel Core i7-3632QM	                                   
133	Intel Core i5-6350HQ	                                   
134	AMD Ryzen 7 2700U	                                   
135	Intel Core i5-6300HQ	                                   
136	Intel Core i5-8350U	                                   
137	AMD Ryzen 3 1200	                                   
138	Intel Core i5-7500T	                                   
139	Intel Core i5-4430	                                   
140	AMD Ryzen 3 2200G	                                   
141	Intel Core i5-8250U	                                   
142	Intel Core i7-2760QM	                                   
143	Intel Core i5-7287U	                                   
144	Intel Core i7-7560U	                                   
145	Intel Core i5-6500T	                                   
146	Intel Core i5-2400	                                   
147	Intel Core i7-2820QM	                                   
148	Intel Core i7-3612QM	                                   
149	AMD Ryzen 5 2500U	                                   
150	Intel Core i7-2720QM	                                   
151	Intel Core i7-2675QM	                                   
152	Intel Core i7-2670QM	                                   
153	Intel Core i5-6400T	                                   
154	Intel Core i7-6567U	                                   
155	Intel Core i5-7360U	                                   
156	Intel Core i5-7267U	                                   
157	AMD Ryzen 3 2300U	                                   
158	Intel Core i7-7500U	                                   
159	Intel Core i5-5350H	                                   
160	Intel Core i5-7300U	                                   
161	Intel Core i7-2635QM	                                   
162	Intel Core i7-2630QM	                                   
163	Intel Core i5-6287U	                                   
164	Intel Core i7-5557U	                                   
165	Intel Core i7-4610M	                                   
166	Intel Core i7-4600M	                                   
167	Intel Core i5-4340M	                                   
168	Intel Core i5-5287U	                                   
169	Intel Core i5-7260U	                                   
170	Intel Core i3-8130U	                                   
171	Intel Core i5-6267U	                                   
172	Intel Core i7-4578U	                                   
173	Intel Core i5-4210H	                                   
174	Intel Core i5-4330M	                                   
175	Intel Core i7-3540M	                                   
176	Intel Core i5-4200H	                                   
177	Intel Core i7-4558U	                                   
178	Intel Core i5-5257U	                                   
179	Intel Core i5-4308U	                                   
180	AMD A10-7850K	4MB	                                   
181	AMD A10-6800K	4MB	                                   
182	Intel Core i5-4310M	                                   
183	Intel Core i7-6600U	                                   
184	Intel Core i7-6650U	                                   
185	Intel Core i7-6560U	                                   
186	Intel Core i5-7200U	                                   
187	Intel Core i5-4300M	                                   
188	Intel Core i3-7100H	                                   
189	Intel Core i7-3520M	                                   
190	Intel Core i7-6500U	                                   
191	Intel Core i7-5600U	                                   
192	Intel Core i7-5650U	                                   
193	Intel Core i5-6360U	                                   
194	Intel Core i5-4210M	                                   
195	Intel Core i5-6300U	                                   
196	Intel Core i5-4288U	                                   
197	Intel Core i5-4278U	                                   
198	Intel Core i5-3380M	                                   
199	Intel Core i5-3360M	                                   
200	AMD A10-7700K	4MB	                                   
201	AMD A8-7650K	4MB	                                   
202	Intel Core i3-3220	                                   
203	Intel Core i5-4200M	                                   
204	Intel Core i5-3340M	                                   
205	Intel Core i7-2640M	                                   
206	Intel Core i7-5500U	                                   
207	Intel Core i7-5550U	                                   
208	Intel Core i5-6260U	                                   
209	Intel Core i5-3320M	                                   
210	Intel Core i5-4258U	                                   
211	AMD A8-6600K	4MB	                                   
212	AMD A10-5800K	4MB	                                   
213	Intel Core i5-3230M	                                   
214	AMD A8-5600K	4MB	                                   
215	Intel Core i7-2620M	                                   
216	Intel Core i7-4600U	                                   
217	Intel Core i7-4650U	                                   
218	Intel Core i3-7167U	                                   
219	Intel Core i5-6198DU	                                   
220	Intel Core i5-6200U	                                   
221	Intel Core i3-7130U	                                   
222	Intel Core i3-6167U	                                   
223	Intel Core i3-6100H	                                   
224	Intel Core i5-5300U	                                   
225	Intel Core i7-3687U	                                   
226	Intel Core i5-5350U	                                   
227	AMD A8-3850	4MB	                                   
228	Intel Core i7-4510U	                                   
229	Intel Core i5-3210M	                                   
230	Intel Core i5-2540M	                                   
231	Intel Core i7-3667U	                                   
232	Intel Core i7-4500U	                                   
233	Intel Core i7-4550U	                                   
234	Intel Core i7-7Y75	                                   
235	Intel Core i5-4310U	                                   
236	Intel Core i5-4360U	                                   
237	AMD FX-9830P	2MB	                                   
238	Intel Core i7-3537U	                                   
239	Intel Pentium G4500T	                                   
240	Intel Core i5-5200U	                                   
241	Intel Core i5-5250U	                                   
242	Intel Core i5-4300U	                                   
243	Intel Core i5-4350U	                                   
244	AMD PRO A12-9830B	                                   
245	Intel Core i5-2520M	                                   
246	Intel Core i3-5157U	                                   
247	Intel Core i5-7Y57	                                   
248	Intel Core i5-7Y54	                                   
249	Intel Core i3-6157U	                                   
250	AMD Ryzen 3 2200U	                                   
251	Intel Core i3-7100U	                                   
252	Apple A11 Bionic	                                   
253	Apple A10X Fusion	                                   
254	Intel Core i3-6100U	                                   
255	Intel Core i3-4110M	                                   
256	Intel Core m3-7Y32	                                   
257	Intel Celeron J4105	                                   
258	AMD FX-9800P	2MB	                                   
259	AMD PRO A12-9800B	                                   
260	Intel Core i5-2450M	                                   
261	Intel Core i7-3517U	                                   
262	Intel Core i3-4100M	                                   
263	Intel Core i5-2435M	                                   
264	Intel Core i5-2430M	                                   
265	Intel Pentium Gold 4415U                                   
266	Intel Core i3-4000M	                                   
267	Intel Core i3-4100E	                                   
268	Intel Core i3-3130M	                                   
269	Intel Core i5-2415M	                                   
270	Intel Core i5-2410M	                                   
271	Intel Core m3-7Y30	                                   
272	Intel Core i5-3437U	                                   
273	AMD A12-9720P	2MB	                                   
274	AMD A12-9700P	2MB	                                   
275	AMD FX-8800P	2MB	                                   
276	AMD Pro A12-8800B	                                   
277	Intel Core i5-4210U	                                   
278	Intel Core i5-4260U	                                   
279	AMD A10-9620P	2MB	                                   
280	Intel Celeron 3965U	                                   
281	Intel Core i3-3120M	                                   
282	Intel Core i5-3427U	                                   
283	Intel Core i5-4402E	                                   
284	Intel Core m7-6Y75	                                   
285	Intel Pentium G860	                                   
286	Intel Core i5-4200U	                                   
287	Intel Core i5-4250U	                                   
288	Intel Core i3-5020U	                                   
289	AMD A10-9600P	2MB	                                   
290	Intel Core i3-3110M	                                   
291	AMD FX-7600P	4MB	                                   
292	Intel Pentium 4405U	                                   
293	Intel Core i7-2649M	                                   
294	Intel Core i3-5010U	                                   
295	Intel Core i3-5015U	                                   
296	Intel Core i3-6006U	                                   
297	Intel Core i3-2370M	                                   
298	Intel Core i3-5005U	                                   
299	Intel Core i3-2350M	                                   
300	Intel Core i3-2348M	                                   
301	Intel Core i5-3337U	                                   
302	Intel Core m5-6Y57	                                   
303	Intel Core m5-6Y54	                                   
304	AMD A10-8700P	2MB	                                   
305	AMD Pro A10-8700B	                                   
306	Intel Core i7-4610Y	                                   
307	Intel Core i7-2629M	                                   
308	Intel Core i7-2677M	                                   
309	AMD A10-7400P	4MB	                                   
310	Intel Pentium 3560M	                                   
311	Intel Core i3-2330M	                                   
312	Intel Core i3-2328M	                                   
313	Intel Pentium 2030M	                                   
314	Intel Pentium 3550M	                                   
315	Intel Core i5-3317U	                                   
316	AMD A8-8600P	2MB	                                   
317	AMD Pro A8-8600B	                                   
318	AMD A8-7200P	4MB	                                   
319	AMD A10-5750M	4MB	                                   
320	AMD A10-5757M	4MB	                                   
321	Intel Core i7-2637M	                                   
322	Intel Core i7-2657M	                                   
323	Intel Core i7-3689Y	                                   
324	Intel Pentium 2020M	                                   
325	Intel Core i3-4158U	                                   
326	Intel Pentium 3825U	                                   
327	Intel Core i3-4120U	                                   
328	Intel Celeron 2970M	                                   
329	Intel Core i5-4300Y	                                   
330	Intel Core i5-4302Y	                                   
331	Intel Pentium B980	                                   
332	Intel Core i3-4030U	                                   
333	Intel Core i3-4025U	                                   
334	Intel Celeron 3865U	                                   
335	Intel Core M-5Y71	                                   
336	AMD A10-4600M	4MB	                                   
337	AMD A10-4657M	4MB	                                   
338	Intel Core i3-2312M	                                   
339	Intel Core i3-2310M	                                   
340	Intel Core i3-2308M	                                   
341	Intel Core i5-2557M	                                   
342	AMD A10-5745M	4MB	                                   
343	AMD A8-5550M	4MB	                                   
344	AMD A8-5557M	4MB	                                   
345	Intel Core m3-6Y30	                                   
346	Intel Core M-5Y51	                                   
347	Intel Core M-5Y70	                                   
348	AMD FX-7500	4MB	                                   
349	Intel Pentium Silver N50                                   
350	Samsung Exynos 9810	                                   
351	AMD A10 Pro-7350B	                                   
352	Intel Celeron 1020E	                                   
353	Intel Core M-5Y31	                                   
354	Intel Core M-5Y10c	                                   
355	Intel Core M-5Y10a	                                   
356	Intel Core M-5Y10	                                   
357	HiSilicon Kirin 970	                                   
358	HiSilicon Kirin 960	                                   
359	Intel Core i7-2617M	                                   
360	Intel Core i5-3439Y	                                   
361	AMD A9-9420	1MB	                                   
362	Intel Core i5-4202Y	                                   
363	Intel Core i5-4220Y	                                   
364	Intel Core i3-4100U	                                   
365	Intel Core i3-3227U	                                   
366	AMD A6-6400K	4MB	                                   
367	AMD A9-9410	1MB	                                   
368	Intel Core i5-4210Y	                                   
369	Intel Core i5-2467M	                                   
370	Intel Core i5-3339Y	                                   
371	Intel Core i3-4010U	                                   
372	Intel Core i3-4005U	                                   
373	Intel Core i3-3217U	                                   
374	Apple A9X		                                   
375	AMD A10-7300	4MB	                                   
376	AMD A8 Pro-7150B	                                   
377	Intel Pentium 4405Y	                                   
378	Intel Core i5-4200Y	                                   
379	Intel Pentium Gold 4415Y                                   
380	Intel Pentium B970	                                   
381	Intel Celeron 3765U	                                   
382	Intel Pentium N4200	                                   
383	Intel Celeron 2950M	                                   
384	AMD A8-7410	2MB	                                   
385	AMD A8-7100	4MB	                                   
386	Intel Core i3-4102E	                                   
387	Intel Core i3-4030Y	                                   
388	Qualcomm Snapdragon 835                                    
389	Samsung Exynos 8895 Octa                                   
390	Samsung Exynos 8890 Octa                                   
391	HiSilicon Kirin 955	                                   
392	AMD A8-3550MX	4MB	                                   
393	AMD A4-5300	2MB	                                   
394	Intel Celeron N4100	                                   
395	Intel Celeron 1020M	                                   
396	Intel Pentium Gold 4410Y                                   
397	Intel Celeron 3965Y	                                   
398	Intel Pentium B960	                                   
399	Intel Pentium 3805U	                                   
400	Intel Core i3-4020Y	                                   
401	Intel Core i3-4012Y	                                   
402	AMD A8-6410	2MB	                                   
403	AMD A6-7310	2MB	                                   
404	AMD A6-6310	2MB	                                   
405	Intel Celeron 3755U	                                   
406	Intel Celeron 3215U	                                   
407	Intel Pentium B950	                                   
408	AMD A8-3530MX	4MB	                                   
409	Intel Core i5-2537M	                                   
410	AMD A8-3510MX	4MB	                                   
411	Intel Pentium 2127U	                                   
412	Intel Pentium B940	                                   
413	Intel Celeron 1005M	                                   
414	HiSilicon Kirin 950	                                   
415	AMD A4-7210	2MB	                                   
416	AMD A6-3430MX	4MB	                                   
417	Intel Pentium 3558U	                                   
418	AMD A6-9220	1MB	                                   
419	Intel Pentium 3556U	                                   
420	Intel Pentium 2117U	                                   
421	Intel Celeron 1000M	                                   
422	Intel Celeron 1037U	                                   
423	Intel Celeron 2981U	                                   
424	Intel Celeron 2980U	                                   
425	Apple A10 Fusion	                                   
426	AMD A8-3520M	4MB	                                   
427	AMD A6-9210		                                   
428	AMD A10-4655M	4MB	                                   
429	AMD A8-4500M	4MB	                                   
430	AMD A8-4557M	4MB	                                   
431	AMD A6-3410MX	4MB	                                   
432	AMD A8-3500M	4MB	                                   
433	AMD A6-3420M	4MB	                                   
434	AMD A8-5545M	4MB	                                   
435	AMD A6-3400M	4MB	                                   
436	AMD A8-4555M	4MB	                                   
437	Intel Celeron B840	                                   
438	AMD A6-5350M	1MB	                                   
439	AMD A6-5357M	1MB	                                   
440	Intel Pentium N3540	                                   
441	AMD A6-5200	2MB	                                   
442	Intel Celeron N3450	                                   
443	Intel Pentium N3710	                                   
444	Intel Atom x7-Z8750	                                   
445	Intel Celeron B830	                                   
446	AMD A4-3330MX	2MB	                                   
447	AMD A4-5150M	1MB	                                   
448	AMD A6-4400M	1MB	                                   
449	Intel Pentium J2900	                                   
450	AMD A4-4300M	1MB	                                   
451	Qualcomm Snapdragon 821                                    
452	Samsung Exynos 7885	                                   
453	Samsung Exynos 7420 Octa                                   
454	Qualcomm Snapdragon 820                                    
455	Nvidia Tegra X1	2.5MB	                                   
456	Intel Pentium N3530	                                   
457	Intel Celeron 1017U	                                   
458	Intel Celeron 3205U	                                   
459	Intel Celeron B820	                                   
460	Intel Pentium N3700	                                   
461	Intel Pentium J2850	                                   
462	Intel Pentium N3520	                                   
463	Intel Celeron J1900	                                   
464	Apple A9		                                   
465	Intel Atom x7-Z8700	                                   
466	Intel Celeron N4000	                                   
467	AMD A4-9120	1MB	                                   
468	Intel Core i3-4010Y	                                   
469	AMD E2-9010	1MB	                                   
470	AMD E2-7110	2MB	                                   
471	AMD A4-6210	2MB	                                   
472	AMD A6-8500P	1MB	                                   
473	AMD Pro A6-8500B	                                   
474	Qualcomm Snapdragon 810                                    
475	Mediatek Helio P25	                                   
476	Qualcomm Snapdragon 652                                    
477	Qualcomm Snapdragon 808                                    
478	Qualcomm Snapdragon 650                                    
479	Intel Atom x5-Z8550	                                   
480	Intel Atom Z3795	                                   
481	Intel Atom Z3785	                                   
482	Intel Atom Z3775	                                   
483	Intel Atom Z3775D	                                   
484	Intel Atom Z3770	                                   
485	Intel Atom Z3770D	                                   
486	Intel Atom x5-Z8500	                                   
487	Intel Celeron N2940	                                   
488	Intel Celeron N3160	                                   
489	Intel Celeron 2957U	                                   
490	Intel Celeron 2955U	                                   
491	Intel Celeron N3350	                                   
492	Intel Celeron 1007U	                                   
493	Intel Celeron N3150	                                   
494	Intel Celeron N2930	                                   
495	Intel Celeron J1850	                                   
496	Intel Pentium N3510	                                   
497	Intel Celeron B815	                                   
498	Intel Celeron B810	                                   
499	Intel Celeron N2920	                                   
500	Intel Core i3-3229Y	                                   
501	Intel Core i3-2377M	                                   
502	Intel Core i3-2375M	                                   
503	Intel Core i3-2367M	                                   
504	Intel Core i3-2365M	                                   
505	AMD A4-5100	2MB	                                   
506	AMD A4-5050	2MB	                                   
507	AMD A4-5000	2MB	                                   
508	AMD E2-6110	2MB	                                   
509	Intel Atom E3845	                                   
510	Apple A8X	2MB + 4M                                   
511	Nvidia Tegra K1 (Denver)                                   
512	Mediatek MT8176		                                   
513	Mediatek MT8173		                                   
514	Mediatek MT8173C	                                   
515	AMD A10 Micro-6700T	                                   
516	AMD A4-3310MX	2MB	                                   
517	AMD A4-3320M	2MB	                                   
518	Mediatek MT6595 Turbo	                                   
519	Samsung Exynos 5433 Octa                                   
520	Apple A8	1MB + 4M                                   
521	Nvidia Tegra K1	2MB	                                   
522	Qualcomm Snapdragon 805                                    
523	Intel Atom Z3580	                                   
524	Intel Atom Z3736F	                                   
525	Intel Atom Z3736G	                                   
526	Intel Atom x5-Z8350	                                   
527	Intel Atom x5-Z8300	                                   
528	Intel Pentium 997	                                   
529	Intel Atom Z3745	                                   
530	Intel Atom Z3745D	                                   
531	Intel Atom Z3740	                                   
532	Intel Atom Z3740D	                                   
533	Intel Atom Z3735D	                                   
534	Intel Atom Z3735E	                                   
535	Intel Atom Z3735F	                                   
536	Intel Atom Z3735G	                                   
537	Intel Celeron 1047UE	                                   
538	AMD E2-3800	2MB	                                   
539	AMD E2-3000M	1MB	                                   
540	Intel Pentium 987	                                   
541	Intel Celeron 887	                                   
542	Intel Celeron B800	                                   
543	Intel Core i3-2357M	                                   
544	AMD E2-9000	1MB	                                   
545	AMD A4-3300M	2MB	                                   
546	AMD A4-3305M	1MB	                                   
547	AMD A6 Pro-7050B	                                   
548	AMD A6-7000	1MB	                                   
549	AMD A6-5345M	1MB	                                   
550	Intel Celeron J1800	                                   
551	Intel Celeron N2840	                                   
552	Intel Celeron J1750	                                   
553	Intel Celeron N3060	                                   
554	Intel Celeron N2910	                                   
555	AMD A6-1450	2MB	                                   
556	AMD A4 Micro-6400T	                                   
557	Qualcomm Snapdragon 630	                                   
558	Qualcomm Snapdragon 626	                                   
559	Qualcomm Snapdragon 801                                    
560	AMD A6-4455M	2MB	                                   
561	AMD A4-5145M	1MB	                                   
562	AMD A4-4355M	2MB	                                   
563	Samsung Exynos 5430 Octa                                   
564	Mediatek Helio P23 MT676                                   
565	Mediatek MT6595	2MB	                                   
566	Intel Celeron N2830	                                   
567	Qualcomm Snapdragon 801                                    
568	Qualcomm Snapdragon 801                                    
569	Intel Celeron N2820	                                   
570	Intel Celeron N3050	                                   
571	Intel Celeron N2815	                                   
572	Intel Celeron N3000	                                   
573	Intel Celeron N2810	                                   
574	Nvidia Tegra 4		                                   
575	Intel Atom Z3680	                                   
576	Intel Atom Z3680D	                                   
577	Mediatek MT6595M	                                   
578	VIA Nano QuadCore L4700	                                   
579	Intel Pentium 3561Y	                                   
580	Intel Pentium 3560Y	                                   
581	Intel Celeron 2961Y	                                   
582	Intel Pentium 2129Y	                                   
583	Qualcomm Snapdragon 801                                    
584	Qualcomm Snapdragon 625	                                   
585	HiSilicon Kirin 925	                                   
586	Qualcomm Snapdragon 800                                    
587	Mediatek Helio P20 (LP4)                                   
588	Samsung Exynos 5420 Octa                                   
589	HiSilicon Kirin 920	                                   
590	Samsung Exynos 7880	                                   
591	HiSilicon Kirin 935	                                   
592	HiSilicon Kirin 659	                                   
593	HiSilicon Kirin 658	                                   
594	Mediatek Helio X10 MT679                                   
595	Mediatek Helio X20 MT679                                   
596	Samsung Exynos 7870 Octa                                   
597	HiSilicon Kirin 655	                                   
598	HiSilicon Kirin 650	                                   
599	HiSilicon Kirin 930	                                   
600	Mediatek Helio P10 MT675                                   
601	Intel Pentium 977	                                   
602	Intel Celeron 877	                                   
603	Apple A7	1MB + 4M                                   
604	Intel Atom Z3570	                                   
605	Intel Pentium 967	                                   
606	Intel Celeron 867	                                   
607	Intel Atom Z3560	                                   
608	AMD E2-3000	1MB	                                   
609	Intel Pentium 957	                                   
610	AMD E1-7010	1MB	                                   
611	Samsung Exynos 5410 Octa                                   
612	Intel Atom Z3480	                                   
613	Intel Atom x3-C3440	                                   
614	Intel Celeron B730	                                   
615	Samsung Exynos 5260 Hexa                                   
616	Samsung Exynos 5410 Octa                                   
617	Intel Celeron 1019Y	                                   
618	Mediatek MT8135		                                   
619	AMD E1-2500	1MB	                                   
620	AMD E1 Micro-6200T	                                   
621	AMD E1-6010	1MB	                                   
622	Intel Atom Z3530	                                   
623	Intel Celeron 847	                                   
624	Intel Celeron 807	                                   
625	Intel Celeron B720	                                   
626	Samsung Exynos 5250 Dual                                   
627	Mediatek MT8752		                                   
628	Mediatek MT6752		                                   
629	Samsung Exynos 7580 Octa                                   
630	Qualcomm Snapdragon 617                                    
631	Qualcomm Snapdragon 616                                    
632	Qualcomm Snapdragon 615                                    
633	Intel Atom D2700	                                   
634	Rockchip RK3288		                                   
635	Mediatek MT6753		                                   
636	Mediatek MT6750		                                   
637	AMD E2-2000	1MB	                                   
638	Intel Celeron N2808	                                   
639	Qualcomm Snapdragon 610                                    
640	MediaTek MT8163 V/A 1.5                                    
641	Mediatek MT6592	1MB	                                   
642	Qualcomm Snapdragon 600                                    
643	Samsung Exynos 7578	                                   
644	HiSilicon Kirin 910T	                                   
645	MediaTek MT8163 V/B 1.3                                    
646	MediaTek MT8161		                                   
647	Intel Atom x3-C3230RK	                                   
648	Qualcomm Snapdragon 435	                                   
649	Qualcomm Snapdragon 430                                    
650	Qualcomm Snapdragon 415                                    
651	AMD E2-1800	1MB	                                   
652	AMD E-450	1MB	                                   
653	AMD E-350	1MB	                                   
654	AMD A4-1350	2MB	                                   
655	Intel Celeron 927UE	                                   
656	Intel Celeron N2807	                                   
657	Intel Celeron N2806	                                   
658	Intel Atom E3827	                                   
659	Intel Atom N2850	                                   
660	Intel Atom Z3460	                                   
661	Qualcomm Snapdragon S4 P                                   
662	Mediatek MT8732		                                   
663	Mediatek MT8165		                                   
664	Mediatek MT6732		                                   
665	Mediatek MT6735		                                   
666	Qualcomm Snapdragon 425	                                   
667	Mediatek MT8735		                                   
668	Mediatek MT6737T	                                   
669	Mediatek MT6737		                                   
670	Rockchip RK3188		                                   
671	Intel Celeron B710	                                   
672	AMD E1-1500	1MB	                                   
673	AMD E1-1200	1MB	                                   
674	AMD E-300	1MB	                                   
675	Samsung Exynos 7570 Quad                                   
676	Qualcomm Snapdragon 410                                    
677	Qualcomm Snapdragon 410                                    
678	HiSilicon Kirin 620	                                   
679	Intel Celeron 797	                                   
680	HiSilicon Kirin 910	                                   
681	Intel Atom D2560	                                   
682	Intel Atom D2550	                                   
683	Intel Atom N2800	                                   
684	AMD E1-2200	1MB	                                   
685	Intel Atom E3826	                                   
686	Intel Celeron N2805	                                   
687	AMD A4-1250	1MB	                                   
688	AMD E1-2100	1MB	                                   
689	AMD A4-1200	1MB	                                   
690	AMD GX-210JA	1MB	                                   
691	Intel Atom Z2760	                                   
692	Intel Atom N2650	                                   
693	Intel Atom E3825	                                   
694	Intel Atom E3805	                                   
695	Intel Atom N2600	                                   
696	Qualcomm Snapdragon 400                                    
697	Qualcomm Snapdragon 400                                    
698	Mediatek MT6735P	                                   
699	Mediatek MT6735M	                                   
700	Marvell Armada PXA1908	                                   
701	Apple A6x		                                   
702	Intel Atom Z2580	                                   
703	Qualcomm Snapdragon S4 P                                   
704	Qualcomm Snapdragon S4 P                                   
705	AMD C-70	1MB	                                   
706	Qualcomm Snapdragon 400                                    
707	AMD C-60	1MB	                                   
708	Qualcomm Snapdragon S4 P                                   
709	Qualcomm Snapdragon S4 P                                   
710	Qualcomm Snapdragon S4 P                                   
711	Intel Atom Z2560	                                   
712	AMD C-50	1MB	                                   
713	AMD Z-60	1MB	                                   
714	AMD Z-01	1MB	                                   
715	Apple A6		                                   
716	Intel Atom x3-C3130	                                   
717	AMD E-240	512KB	                                   
718	Samsung Exynos 4412 Quad                                   
719	NVIDIA Tegra 3		                                   
720	Mediatek MT8127	512KB	                                   
721	Mediatek MT6589T	                                   
722	Mediatek MT8389	1MB	                                   
723	Mediatek MT8125	1MB	                                   
724	Spreadtrum SC9830A	                                   
725	Samsung Exynos 3470 Quad                                   
726	Samsung Exynos 3475 Quad                                   
727	Mediatek MT8121	1MB	                                   
728	Mediatek MT6582	512KB	                                   
729	Mediatek MT6582M	                                   
730	Mediatek MT6580M	                                   
731	Spreadtrum SC7731	                                   
732	Qualcomm Snapdragon 212                                    
733	Qualcomm Snapdragon 400                                    
734	Qualcomm Snapdragon 400                                    
735	Qualcomm Snapdragon 400                                    
736	Mediatek MT6589		                                   
737	Qualcomm Snapdragon 200                                    
738	Qualcomm Snapdragon 210                                    
739	Marvell PXA1088		                                   
740	Qualcomm Snapdragon S4 P                                   
741	Qualcomm Snapdragon S4 P                                   
742	Qualcomm 205		                                   
743	Intel Atom Z2480	                                   
744	Intel Atom E3815	                                   
745	AMD C-30	512KB	                                   
746	Intel Atom Z2460	                                   
747	Qualcomm Snapdragon S4 P                                   
748	Samsung Exynos 4212 1.5                                    
749	Texas Instruments OMAP 4                                   
750	HiSilicon k3v2 Hi3620	                                   
751	Rockchip RK3066 1.5 GHz	                                   
752	Qualcomm Snapdragon S4 P                                   
753	Qualcomm Snapdragon 200                                    
754	Qualcomm Snapdragon S4 P                                   
755	MediaTek MT8312		                                   
756	Renesas MP5232		                                   
757	Broadcom BCM21664T	                                   
758	Marvell PXA986		                                   
759	Amlogic AML8726-MX	                                   
760	Qualcomm Snapdragon S3 M                                   
761	Qualcomm Snapdragon S3 M                                   
762	Samsung Exynos 4210 1.4                                    
763	Texas Instruments OMAP 4                                   
764	Rockchip RK3168		                                   
765	Samsung Exynos 4210 1.2                                    
766	MediaTek MT8377	1MB	                                   
767	Broadcom BCM28155	                                   
768	Texas Instruments OMAP 4                                   
769	MediaTek MT6572	1MB	                                   
770	Spreadtrum SC8830	                                   
771	Apple A5x		                                   
772	Qualcomm Snapdragon S4 P                                   
773	Intel Atom Z2420	                                   
774	Apple A5		                                   
775	Nvidia Tegra 2 (250)	                                   
776	Qualcomm Snapdragon 200                                    
777	MediaTek MT8317T	                                   
778	MediaTek MT6577		                                   
779	ST-Ericsson NovaThor U85                                   
780	ST-Ericsson NovaThor U84                                   
781	MediaTek MT6575		                                   
782	Qualcomm Snapdragon S2 M                                   
783	Rockchip RK2918 1.2 GHz	                                   
784	AllWinner A10		                                   
785	ARM Cortex A8 1.2 GHz	                                   
786	Apple A4		                                   
787	AllWinner A13		                                   
788	WonderMedia PRIZM WM8950                                   
789	Samsung Hummingbird S5PC                                   
790	Qualcomm Snapdragon S1 M                                   
791	Qualcomm Snapdragon S1 M                                   
792	Texas Instruments OMAP 3                                   
793	Texas Instruments OMAP 3                                   
794	Rockchip RK2918		                                   
795	Telechips TCC8803 1GHz	                                   
796	ZiiLABS ZMS-08		                                   
797	ARM Cortex A8 1GHz	                                   
798	Actions ACT-ATM7029	                                   
799	Qualcomm Snapdragon S1 Q                                   
800	Loongson 2F 900MHz	                                   
801	Qualcomm Snapdragon S1 M                                  
802	CSR8670		0" >/cpu
fi
{
    for ((i = 1 ; i <= 100 ; i+=1)); do
	sleep 0.01
        echo $i
    done
} | whiptail --gauge "正在测试CPU(独家算法)" 6 60 0
w=`getconf LONG_BIT`
r=`cat /proc/cpuinfo |grep MHz | cut -d":" -f 2 | head -1 `
h=`cat /proc/cpuinfo |grep MHz | wc -l`
q=`cat /cpu | grep $bjcpu | awk '{print $1}'`
e=`echo $q | awk '{print 100-($1/800*100)}'`
if [ $aOPTION = 1 ]
then
whiptail --title "测试结果" --msgbox "您的CPU型号是$bjcpu 排在世界第$q位 超过了$e%的CPU\n CPU运行模式$w位\n CPU主频$r\n CPU核数$h" 10 60
rm -f /cpu
fi
