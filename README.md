# tfhe
Fast Fully Homomorphic Encryption Library over the Torus

**version 1.0-rc1** -- *first pre-release date: 2017.04.05*

**version 0.1** -- *Proof of concept release date: 2016.08.18*

TFHE is open-source software distributed under the terms of the Apache 2.0 license. 
The scheme is described in the paper "Faster fully homomorphic encryption: Bootstrapping in less than 0.1 seconds" presented at the IACR conference Asiacrypt 2016 by Ilaria Chillotti, Nicolas Gama, Mariya Georgieva, Malika Izabachène.


### Description 

The TFHE library implements a very fast gate-by-gate bootstrapping, based on [CGGI16]. Namely, any binary 
gate is evaluated homomorphically in about 20 milliseconds on a single
core which improves [DM15] by a factor 30, and the mux gate takes about 40 CPU-ms (or 20ms on 2 cores). 

The library implements a Ring-variant of the GSW [GSW13]
cryptosystem and makes many optimizations described in [DM15] and [CGGI16]. 

It also implements a dedicated Fast Fourier
Transformation for the anticyclic ring R[X]/(X^N+1), and uses AVX assembly vectorization instructions. 
The default parameter set achieves at least 110-bit of cryptographic security, based on ideal lattice assumptions.

From the user point of view, the library can evaluate a net-list of binary gates homomorphically at a rate of about 50 gates per second per core, without decrypting its input. It suffices to provide the sequence of gates, as well as ciphertexts of the input bits. And the
library computes ciphertexts of the output bits.

Unlike other libraries, TFHE has no restriction on the number of gates or on their composition. This makes the library usable with either
manually crafted circuits, or with the output of automated circuit generation tools. For TFHE, optimal circuits have the smallest possible number of gates, 
and to a lesser extent, the possibility to evaluate them in parallel. 



### Dependencies 


The library interface can be used in a regular C code. However, to compile the core of the library you will need a standard C++11 compiler.
Currently, the project has only been tested with the g++ compiler under Linux. In the future, we plan to extend the compatibility to other compilers, platforms and operating systems.

At least one FFT processor is needed to run the project:

* The default processor comes from Project Nayuki, who proposes two implementations of the fast Fourier transform - one in portable C, and the other using the AVX assembly instructions.
This component is licensed under the MIT license, and we added the code of the reverse FFT (both in C and in assembly). Original source: https://www.nayuki.io/page/fast-fourier-transform-in-x86-assembly
* we provide another processor, named the spqlios processor, which is written in AVX and FMA assembly in the style of the nayuki processor, and which is dedicated to the ring R[X]/(X^N+1) for N a power of 2.
* We also provide a connector for the FFTW3 library: http://www.fftw.org. With this library, the performance of the FFT is between 2 and 3 times faster than the default Nayuki implementation. However, you should keep in mind that the library FFTW is published under the GPL License. If you choose to use this library in a final product, this product may have to be released under GPL License as well (other commercial licenses are available on their web site)
* We plan to add other connectors in the future (for instance the Intel’s IPP Fourier Transform, which should be 1.5× faster than FFTW for 1D real data)


### Installation

To build the library with the default options, run ```make``` and ```make install``` from the top level directory of the TFHE project. This assumes that the standard tool cmake is already installed on the system, and an
up-to-date c++ compiler (i.e. g++ >=5.2) as well.
It will compile the library in optimized mode, and install it to ```/usr/local/lib``` folder.
Currently, only static libraries are generated. 

If you want to choose additional compile options (i.e. other installation folder, debug mode, tests, fftw), you need to run cmake manually and pass the desired options:
```
mkdir build
cd build
cmake ../src -DENABLE_TESTS=on -DENABLE_FFTW=on -DCMAKE_BUILD_TYPE=debug
make
```
The available options are the following:

| Variable Name          | values           | 
|------------------------|-------|
| CMAKE_INSTALL_PREFIX   | */usr/local* installation folder (libs go in lib/ and headers in include/) | 
| CMAKE_BUILD_TYPE       | <ul><li>*optim* enables compiler's optimization flags, including native architecture specific optimizations</li><li>*debug* disables any optimization and include all debugging info (-g3 -O0)</li> | 
| ENABLE_TESTS           | *on/off* compiles the library's unit tests and sample applications in the test/ folder. This assumes that googletest>1.8 is installed on the system. (use ```ctest``` to run all tests) | 
| ENABLE_FFTW            | *on/off* compiles libtfhe-fftw.a, using FFTW3 (GPL licence) for fast FFT computations |
| ENABLE_NAYUKI_PORTABLE | *on/off* compiles libtfhe-nayuki-portable.a, using the fast C version of nayuki for FFT computations |
| ENABLE_NAYUKI_AVX      | *on/off* compiles libtfhe-nayuki-avx.a, using the avx assembly version of nayuki for FFT computations |
| ENABLE_SPQLIOS_AVX     | *on/off* compiles libtfhe-spqlios-avx.a, using tfhe's dedicated avx assembly version for FFT computations |
| ENABLE_SPQLIOS_FMA     | *on/off* compiles libtfhe-spqlios-fma.a, using tfhe's dedicated fma assembly version for FFT computations |

### References

[CGGI16]: I. Chillotti, N. Gama, M. Georgieva, and M. Izabachène. Faster fully homomorphic encryption: Bootstrapping in less than 0.1 seconds. In Asiacrypt 2016, pages 3-33.

[DM15]:   L. Ducas and D. Micciancio.  FHEW: Bootstrapping homomorphic encryption in less than a second.  In Eurocrypt 2015, pages 617-640.

[GSW13]:  C. Gentry, A. Sahai, and B. Waters. Homomorphic encryption from learning with errors:  Conceptually-simpler,  asymptotically-faster,  attribute-based. In Crypto 2013, pages 75-92


+++++++++++++++++++++++++++++++++++++++++++++
以下是运行结果：

[qwe@localhost test]$ ./test-addition-boot-fftw
starting bootstrapping addition circuit (FA in MUX version)...trial 0
finished bootstrappings addition circuit (FA in MUX version)
total time (microsecs)... 14540000
starting bootstrapping addition circuit (FA)...trial 0
finished bootstrappings addition circuit (FA)
total time (microsecs)... 14770000
starting bootstrapping comparison...trial 0
finished bootstrappings comparison
total time (microsecs)... 8520000
starting bootstrapping addition circuit (FA in MUX version)...trial 1
finished bootstrappings addition circuit (FA in MUX version)
total time (microsecs)... 14790000
starting bootstrapping addition circuit (FA)...trial 1
finished bootstrappings addition circuit (FA)
total time (microsecs)... 14900000
starting bootstrapping comparison...trial 1
finished bootstrappings comparison
total time (microsecs)... 8610000
starting bootstrapping addition circuit (FA in MUX version)...trial 2
finished bootstrappings addition circuit (FA in MUX version)
total time (microsecs)... 15510000
starting bootstrapping addition circuit (FA)...trial 2
finished bootstrappings addition circuit (FA)
total time (microsecs)... 14940000
starting bootstrapping comparison...trial 2
finished bootstrappings comparison
total time (microsecs)... 8550000
starting bootstrapping addition circuit (FA in MUX version)...trial 3
finished bootstrappings addition circuit (FA in MUX version)
total time (microsecs)... 14860000
starting bootstrapping addition circuit (FA)...trial 3
finished bootstrappings addition circuit (FA)
total time (microsecs)... 15550000
starting bootstrapping comparison...trial 3
finished bootstrappings comparison
total time (microsecs)... 8990000
starting bootstrapping addition circuit (FA in MUX version)...trial 4
finished bootstrappings addition circuit (FA in MUX version)
total time (microsecs)... 15080000
starting bootstrapping addition circuit (FA)...trial 4
finished bootstrappings addition circuit (FA)
total time (microsecs)... 15270000
starting bootstrapping comparison...trial 4
finished bootstrappings comparison
total time (microsecs)... 8770000
starting bootstrapping addition circuit (FA in MUX version)...trial 5
finished bootstrappings addition circuit (FA in MUX version)
total time (microsecs)... 14920000
starting bootstrapping addition circuit (FA)...trial 5
finished bootstrappings addition circuit (FA)
total time (microsecs)... 15270000
starting bootstrapping comparison...trial 5
finished bootstrappings comparison
total time (microsecs)... 8830000
starting bootstrapping addition circuit (FA in MUX version)...trial 6
finished bootstrappings addition circuit (FA in MUX version)
total time (microsecs)... 14850000
starting bootstrapping addition circuit (FA)...trial 6
finished bootstrappings addition circuit (FA)
total time (microsecs)... 15790000
starting bootstrapping comparison...trial 6
finished bootstrappings comparison
total time (microsecs)... 9040000
starting bootstrapping addition circuit (FA in MUX version)...trial 7
finished bootstrappings addition circuit (FA in MUX version)
total time (microsecs)... 14970000
starting bootstrapping addition circuit (FA)...trial 7
finished bootstrappings addition circuit (FA)
total time (microsecs)... 14940000
starting bootstrapping comparison...trial 7
finished bootstrappings comparison
total time (microsecs)... 8770000
starting bootstrapping addition circuit (FA in MUX version)...trial 8
finished bootstrappings addition circuit (FA in MUX version)
total time (microsecs)... 14640000
starting bootstrapping addition circuit (FA)...trial 8
finished bootstrappings addition circuit (FA)
total time (microsecs)... 15150000
starting bootstrapping comparison...trial 8
finished bootstrappings comparison
total time (microsecs)... 8710000
starting bootstrapping addition circuit (FA in MUX version)...trial 9
finished bootstrappings addition circuit (FA in MUX version)
total time (microsecs)... 14950000
starting bootstrapping addition circuit (FA)...trial 9
finished bootstrappings addition circuit (FA)
total time (microsecs)... 15240000
starting bootstrapping comparison...trial 9
finished bootstrappings comparison
total time (microsecs)... 9220000
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

[qwe@localhost test]$ ./test-bootstrapping-fft-fftw
starting bootstrapping...
finished 50 bootstrappings
time per bootstrapping (microsecs)... 47400
phase 0 = 0.127183
phase 1 = 0.126483
phase 2 = 0.130081
phase 3 = 0.127854
phase 4 = 0.119718
phase 5 = 0.129209
phase 6 = 0.122811
phase 7 = 0.122402
phase 8 = 0.119233
phase 9 = 0.124724
phase 10 = 0.114564
phase 11 = 0.125153
phase 12 = 0.128393
phase 13 = 0.124639
phase 14 = 0.118714
phase 15 = 0.117973
phase 16 = 0.126234
phase 17 = 0.127249
phase 18 = 0.115481
phase 19 = 0.124247
phase 20 = 0.115275
phase 21 = 0.123618
phase 22 = 0.128594
phase 23 = 0.122843
phase 24 = 0.123974
phase 25 = 0.130829
phase 26 = -0.123853
phase 27 = -0.129911
phase 28 = -0.125645
phase 29 = -0.130038
phase 30 = -0.127353
phase 31 = -0.126543
phase 32 = -0.120549
phase 33 = -0.132103
phase 34 = -0.125525
phase 35 = -0.126201
phase 36 = -0.124665
phase 37 = -0.124523
phase 38 = -0.125884
phase 39 = -0.119486
phase 40 = -0.130634
phase 41 = -0.126222
phase 42 = -0.121219
phase 43 = -0.130144
phase 44 = -0.12621
phase 45 = -0.131009
phase 46 = -0.132584
phase 47 = -0.129007
phase 48 = -0.126289
phase 49 = -0.124964

[qwe@localhost test]$ ./test-c-binding-fftw
in_message: -1073741824
starting bootstrapping...
finished bootstrapping in (microsecs)... 175000.000000
end_variance: 0.003840
end_phase: -1192759392
 end_message: -1073741824

[qwe@localhost test]$ ./test-decomp-tgsw-fftw
-------------
WARNING:
All the tests below are supposed to fail with proba: 0
It is normal and it is part of the test!
-------------
Test decompH on TorusPolynomial
Test TLweSymDecrypt on muB:
 variance: 1e-12
Test decompH on TLwe(muB)
Test cipher after product 3.5 H*muB:
Test LweSymDecrypt after product 3.5 H*muB:
 variance: 1e-12
----------------------
decryption test tgsw:
manual decryption test:
automatic decryption test:
Test LweSymDecrypt after product 3.5:
 variance: 0.000535351


[qwe@localhost test]$ ./test-gate-bootstrapping-fftw
starting bootstrapping NAND tree...trial 0
finished bootstrappings NAND tree
time per bootNAND gate (microsecs)... 47142.9
starting bootstrapping NAND tree...trial 1
finished bootstrappings NAND tree
time per bootNAND gate (microsecs)... 46984.1
starting bootstrapping NAND tree...trial 2
finished bootstrappings NAND tree
time per bootNAND gate (microsecs)... 46349.2
starting bootstrapping NAND tree...trial 3
finished bootstrappings NAND tree
time per bootNAND gate (microsecs)... 45873
starting bootstrapping NAND tree...trial 4
finished bootstrappings NAND tree
time per bootNAND gate (microsecs)... 46031.7
starting bootstrapping NAND tree...trial 5
finished bootstrappings NAND tree
time per bootNAND gate (microsecs)... 45396.8
starting bootstrapping NAND tree...trial 6
finished bootstrappings NAND tree
time per bootNAND gate (microsecs)... 45873
starting bootstrapping NAND tree...trial 7
finished bootstrappings NAND tree
time per bootNAND gate (microsecs)... 45873
starting bootstrapping NAND tree...trial 8
finished bootstrappings NAND tree
time per bootNAND gate (microsecs)... 46190.5
starting bootstrapping NAND tree...trial 9
finished bootstrappings NAND tree
time per bootNAND gate (microsecs)... 46031.7



[qwe@localhost test]$ ./test-long-run-fftw
0 6 -0.00432882
1 3 -0.00915798
2 9 0.000943479
3 4 0.00446989
4 10 0.00350101 
5 7 0.000592489
6 7 -0.00276405
7 6 -0.00726098
8 6 0.000978254
9 9 -0.003079
10 7 0.000183967
11 3 -0.00469712
12 5 -0.00170577
13 5 0.00324293
14 10 0.00518962
15 4 -0.00785712
16 10 0.00119726
17 10 -0.000199102
18 10 0.00799019
19 7 0.00439417
20 10 -0.0011927
21 0 -0.000199195
22 2 -0.00368522
23 3 0.00119355
24 8 -0.00716676
25 9 0.00500899
26 6 0.0011945
27 8 0.00224265
28 2 -0.0028087
29 10 0.00290138
30 3 -0.00195109
31 0 -0.0013898
32 10 -0.00173498
33 5 -0.00298977
34 3 0.00280444
35 1 -0.00628274
36 2 -0.00420917
37 9 0.00548399
38 7 -0.000825041
39 1 -0.00292313
40 5 -0.00236499
41 10 0.000501797
42 8 0.00163236
43 3 -0.00218292
44 6 -0.00158608
45 10 -0.00440211
46 6 0.000893482
47 9 0.000453599
48 8 -0.0131765
49 7 0.0011945
50 5 0.00152538
51 10 0.00296775
52 2 -0.00430493
53 4 0.00107248
54 1 -0.00316442
55 10 -0.00969715
56 3 -0.00309965
57 0 0.000212276
58 3 -0.0123108
59 0 0.00392747
60 6 -0.000703794
61 9 0.000831085
62 7 0.00770794
63 4 -0.00770454
64 8 -0.00555579
65 1 0.000212276
66 1 -0.00311686
67 4 -0.00118458
68 6 0.00373692
69 10 0.000891729
70 7 0.00536258
71 0 0.000691833
72 8 -0.00431028
73 1 -0.00077354
74 7 2.56449e-05
75 2 -0.00189119
76 5 0.00269577
77 5 -0.00759269
78 4 0.000710685
79 7 0.0011945
80 1 -0.00404665
81 3 -0.00386461
82 0 0.0030432
83 4 -0.000973711
84 1 -0.00314977
85 8 0.0011945
86 5 0.00305074
87 5 -0.00303664
88 8 -0.00372308
89 0 -0.000280808
90 10 -0.00974044
91 4 -0.00297683
92 3 -0.000137079
93 10 -0.00826477
94 7 0.00572701
95 0 -0.00459454
96 0 0.00280993
97 5 -0.00222463
98 10 -0.000833455
99 3 0.0073875
100 2 0.00225691
101 6 0.00216538
102 2 -0.00574089
103 4 -0.0027986
104 9 0.000901586
105 4 -0.000698308
106 0 -0.00562145
107 0 -0.00594491
108 0 0.000266254
109 7 -0.0033038
110 5 -0.0033038
111 6 0.00614493
112 6 -0.00798607
113 4 0.00301056
114 1 0.00166139
115 7 -0.0041282
116 3 0.00304558
117 9 0.00154921
118 0 -0.00278823
119 3 0.000503597
120 6 -0.00453499
121 0 -0.0135358
122 2 -0.00451467
123 2 0.00458527
124 4 -0.00593883
125 1 0.00354376
126 5 -0.000313258
127 3 -0.00548256
128 2 -0.00384837
129 8 0.00026026
130 1 0.00721847
131 2 0.000485178
132 0 -0.00393664
133 3 0.00250701
134 6 -0.00228018
135 0 0.00113564
136 4 -0.00395113
137 8 0.0011945
138 10 -0.00870599
139 5 -0.00193308
140 5 -0.00603713
141 1 -0.00619339
142 5 -0.00361385
143 1 0.00119712
144 2 -0.00234718
145 9 0.00243202
146 9 -0.00120659
147 4 -0.00622257
148 10 -0.00511981
149 7 -0.00449376
150 3 0.00521826
151 3 -0.00828323
152 5 -0.00319681
153 7 0.00146943
154 4 -0.00226954
155 4 0.0021149
156 5 -0.00383448
157 6 -0.00342492
158 6 0.000108069
159 0 -0.00649605
160 6 -0.00122439
161 5 0.00578595
162 6 -0.00390066
163 3 -0.00793379
164 3 -0.00863115
165 10 0.0028934
166 8 -0.00797978
167 10 -0.00462855
168 10 0.000578977
169 5 -0.000445761
170 6 0.00363968
171 8 -0.00196923
172 1 -0.00322778
173 5 0.00122426
174 4 -0.00373708
175 0 0.00302602
176 3 0.00383479
177 4 -1.4653e-05
178 9 -0.00158208
179 9 0.00294827
180 1 -0.00167904
181 7 0.00604222
182 8 -0.00438776
183 4 0.00383162
184 1 0.00314053
185 10 -0.00917714
186 4 -0.00255462
187 5 -0.00324742
188 4 0.00197481
189 2 -0.00370083
190 9 -0.00324146
191 3 -0.000514405
192 10 -0.000258561
193 0 -0.0035405
194 2 -0.00872307
195 4 0.00214871
196 2 0.00739187
197 3 0.00114334
198 9 -0.00281209
199 5 -0.00360473
200 6 0.00113159
201 1 -0.00272852
202 3 0.0054176
203 4 -8.29303e-05
204 3 0.000751077
205 6 -0.00909945
206 2 -0.00658945
207 1 -0.0101055
208 7 -0.00631827
209 3 -0.00976443
210 2 -0.00841245
211 7 -0.00490385
212 0 -0.000498901
213 8 0.00534425
214 2 0.00734715
215 9 0.00534425
216 5 0.00478402
217 4 -0.00180164
218 4 -0.00292598
219 7 0.00152453
220 2 0.00585288
221 8 0.000800015
222 1 -0.0107569
223 9 0.00472807
224 3 -0.0025326
225 10 -0.00787716
226 3 0.0016268
227 4 -0.0121695
228 8 -0.00549088
229 1 -0.00703773
230 8 -0.00626998
231 8 -0.00909493
232 1 -0.00410494
233 9 -0.00489438
234 8 -0.00159735
235 10 -0.00226212
236 6 -0.0039972
237 0 0.0024008
238 2 0.00306377
239 8 -0.00204807
240 6 -0.00104317
241 3 0.00483055
242 8 -0.00179135
243 4 -0.00152015
244 8 -0.0115595
245 0 0.00144936
246 3 0.00338255
247 10 -0.0107876
248 6 -0.00311257
249 3 -0.00647053
250 3 -0.00647053
251 8 -0.0037922
252 8 0.00669101
253 4 0.00661816
254 1 -0.00046976
255 0 0.00359052
256 4 -0.00541263
257 5 -0.00268983
258 5 0.00213091
259 6 0.00013825
260 8 0.0011945
261 8 0.00409136
262 4 0.000556665
263 9 -0.00261926
264 6 -0.011506
265 10 -0.00552231
266 6 -0.00627034
267 7 -0.000749473
268 8 -0.00483174
269 4 -0.00842125
270 5 -0.0030941
271 8 -0.00746901
272 7 -0.00457694
273 5 -0.00255836
274 3 0.00444774
275 1 -0.00750079
276 4 -0.00477768
277 3 0.00711955
278 0 -0.00172377
279 8 0.00161712
280 9 0.0030782
281 9 0.00545593
282 0 -0.000566992
283 0 -0.00724627
284 8 -0.00343094
285 5 -0.00427848
286 2 -0.00130679
287 1 -0.00244497
288 10 0.00203603
289 4 5.01778e-05
290 1 -0.00538648
291 5 0.000143963
292 10 -0.00280348
293 9 0.00102981
294 8 0.00256881
295 4 0.00306266
296 8 0.00416893
297 3 0.00501081
298 1 -0.0045187
299 3 0.00200834
300 6 4.94288e-05
301 0 0.00690127
302 4 6.08629e-05
303 6 -0.00207734
304 2 -0.00499016
305 6 0.00266964
306 3 -0.00162453
307 8 0.0022885
308 3 -0.0074143
309 6 -0.00541746
310 10 -0.00915749
311 6 -0.0094545
312 4 -0.00327275
313 5 0.00723166
314 5 -0.0066339
315 1 -0.00137371
316 8 0.00330524
317 9 0.000230724
318 4 0.00295244
319 10 0.00280707
320 6 0.000261991
321 6 0.00332819
322 8 0.000365027
323 10 -0.00731321
324 1 -0.000446447
325 10 -0.00925931
326 1 -0.00401088
327 3 0.00121868
328 5 -0.0030722
^C
[qwe@localhost test]$ 

[qwe@localhost test]$ ./test-lwe-fftw
a = [0.360936, 0.0268472, 0.259587, 0.48859, 0.164528, 0.371637, -0.41431, 0.469863, -0.438076, 0.0800416, 0.0525924, 0.163614, 0.467621, 0.181042, 0.227536, 0.12022, -0.289211, 0.144883, -0.391807, -0.144218, -0.308589, -0.270119, -0.102324, 0.00161439, -0.167656, 0.0934124, -0.196999, -0.326254, -0.245171, -0.47929, -0.116467, -0.240348, -0.455504, 0.130889, -0.383696, 0.234749, 0.0171215, 0.0158194, -0.231736, 0.201791, -0.425805, 0.465957, 0.286403, -0.0273749, -0.328193, -0.451731, 0.0112025, 0.428438, 0.337262, -0.404008, -0.429645, 0.293008, -0.48683, 0.462752, 0.415628, 0.0807097, -0.234286, -0.225632, 0.333983, 0.285791, 0.220657, -0.248863, -0.238968, -0.48247, -0.44641, 0.275915, 0.305555, 0.243341, 0.348498, 0.243425, 0.355225, 0.138323, 0.140052, 0.298738, 0.115135, -0.0502394, -0.174243, -0.032032, -0.070617, -0.0237845, 0.0614749, 0.351236, 0.0538694, 0.172288, -0.121189, 0.165379, -0.213409, 0.101241, -0.0128261, 0.402456, -0.42021, -0.425374, 0.190304, 0.325647, -0.469929, 0.0157019, 0.405948, 0.469936, 0.289931, 0.0947743, 0.0449265, -0.291602, -0.162654, 0.406523, 0.448262, -0.311258, 0.343789, -0.461589, -0.26118, 0.48794, 0.340599, 0.0367555, 0.241936, 0.249829, -0.426902, -0.459839, -0.0184199, -0.401846, 0.28784, 0.292837, 0.184101, 0.300066, 0.0743937, -0.260111, 0.323248, 0.399517, 0.178836, 0.167153, -0.166572, -0.198875, -0.0395852, 0.258266, 0.132067, -0.0831759, -0.18269, -0.270977, 0.0779365, -0.10256, 0.144327, 0.160306, 0.359578, 0.18668, -0.463075, -0.216909, -0.321237, 0.231529, 0.472226, 0.0252408, 0.297964, -0.44771, 0.416689, 0.329297, -0.140103, 0.418541, 0.267438, 0.161714, 0.418188, 0.267978, 0.121614, -0.376513, -0.0820015, 0.311621, 0.435642, -0.161967, 0.227274, 0.0161347, 0.427541, 0.330713, 0.0299799, 0.08821, -0.0513776, -0.154534, 0.28467, 0.136221, -0.0192819, -0.108763, -0.0199726, 0.2867, -0.435479, 0.252529, 0.0591986, -0.306646, 0.415548, -0.438278, -0.0756523, -0.447219, -0.319516, 0.290485, 0.0785771, -0.415445, -0.164324, 0.443255, 0.170924, 0.34982, -0.41502, 0.0365919, -0.4177, 0.386601, -0.283036, -0.0353393, -0.366857, 0.39639, -0.393042, -0.309686, -0.0357362, 0.178167, -0.10443, 0.191206, -0.334354, -0.0428159, 0.471035, 0.17603, -0.214054, 0.408658, 0.217688, 0.174578, -0.0404407, 0.37229, -0.111791, -0.193971, 0.0629611, 0.0666467, -0.436985, -0.124738, -0.270543, -0.158027, -0.0728818, -0.439912, -0.469869, 0.299597, 0.0268634, 0.0159192, -0.0127665, -0.386119, -0.276093, 0.466503, -0.243251, 0.429755, -0.187997, 0.322195, -0.487, 0.280162, 0.0603454, 0.0688578, 0.2713, 0.4433, -0.318703, -0.350394, 0.346963, -0.299223, 0.258798, -0.0503663, 0.344567, -0.295361, -0.403677, 0.316469, 0.173216, 0.246104, 0.159275, 0.193456, 0.382766, -0.0190397, 0.271412, -0.399192, 0.25688, 0.0733357, -0.238108, -0.214187, 0.339355, -0.0776796, -0.127963, 0.201392, 0.277726, 0.307251, -0.480168, 0.171745, -0.414303, 0.211923, 0.365186, 0.182822, 0.0433029, 0.209083, -0.337369, 0.0550661, 0.0296735, 0.458989, 0.429256, -0.0768373, -0.167827, 0.486597, 0.0796733, -0.358334, 0.141116, 0.215412, 0.379598, -0.415759, -0.498091, -0.410924, -0.165863, -0.266516, -0.453178, -0.173977, 0.101957, -0.491963, -0.445458, 0.280567, -0.48498, -0.256476, 0.274453, 0.376668, -0.413771, 0.190213, -0.349305, 0.445226, 0.354239, 0.26315, 0.0457668, 0.391065, -0.346071, -0.121687, 0.322673, -0.422884, -0.2724, 0.081214, -0.416357, 0.492716, -0.333215, -0.322837, -0.338925, 0.320688, 0.0188414, 0.039107, 0.245561, -0.373641, 0.329307, -0.499168, -0.0222422, 0.0827032, -0.0195221, -0.372719, 0.121505, -0.225386, -0.000854963, -0.31248, -0.127239, 0.320833, 0.0512341, -0.0683196, 0.465488, 0.4877, 0.415335, -0.405189, 0.187718, -0.201526, -0.111508, -0.0582177, -0.00266943, -0.250113, 0.455426, -0.0487532, -0.225817, 0.131576, 0.167803, 0.226442, 0.333552, -0.0903975, 0.270898, 0.203375, -0.14886, -0.169411, 0.138197, 0.150731, -0.0128799, -0.295021, -0.101981, -0.198997, 0.0365192, 0.19169, 0.195466, 0.279554, 0.00557157, -0.306309, 0.134293, -0.41919, 0.404155, -0.404165, 0.324077, 0.0364274, 0.189478, -0.253373, -0.391877, 0.176563, 0.219575, -0.211681, 0.0716221, 0.249918, -0.413536, 0.187311, -0.417658, -0.225093, 0.175934, -0.0421563, 0.403177, 0.0217036, 0.0650495, 0.48461, 0.415342, -0.346969, 0.166434, 0.0411973, 0.102077, -0.418032, -0.401268, -0.376487, 0.433996, -0.201649, 0.210026, 0.147397, 0.23716, -0.267984, -0.170968, -0.218847, -0.470401, -0.130919, -0.263405, 0.236961, -0.246805, -0.301756, 0.318161, 0.371001, -0.106146, 0.420558, 0.472405, 0.472981, -0.0856476, -0.3857, -0.0692853, -0.0226744, 0.375052, -0.298146, -0.318971, -0.398037, 0.41179, 0.20755, 0.30168, 0.0650888, -0.381584, 0.340372, -0.427004, -0.133701, -0.392276, -0.08042, 0.135351, -0.188593, 0.228866, -0.137383, -0.293582, 0.0511287, 0.217886, -0.378761, -0.184079, 0.27232, -0.264835, 0.426899, 0.0909905, 0.265465, 0.362646, -0.381127, 0.433944, 0.0193299, -0.0466466, -0.204143, 0.105671, -0.208941, 0.0775293, -0.346237, 0.184304, -0.482515, -0.114703, 0.151436, 0.483627, 0.348913, 0.0772153, 0.28273, -0.493769, 0.402747, 0.287826, -0.244587, 0.237388, 0.292591, -0.137189, 0.172594, 0.0164785, 0.204571, 0.0812665, -0.0264847, -0.333681, 0.417517, 0.220695, 0.0295229, 0.322143, 0.104443, 0.18351, 0.0618616, 0.406617, -0.229722, -0.133556, 0.274841, 0.35341, 0.360474, 0.0921785, 0.15207]
b = 0.185321
phi = 0.490627
message = -0.5
There were 0 failures out of 1000 trials
(it might be normal)

[qwe@localhost test]$ ./test-multiplication-fftw
torusPolynomialMultNaive: 370 clock cycles (average)
torusPolynomialMultNaive time: 0.00037 seconds

torusPolynomialMultKaratsuba: 190 clock cycles (average)
torusPolynomialMultKaratsuba time: 0.00019 seconds

torusPolynomialMultFFT: 50 clock cycles (average)
torusPolynomialMultFFT time: 5e-05 seconds


[qwe@localhost test]$ ./test-tlwe-fftw
-------------
WARNING:
All the tests below are supposed to fail with proba: 0.000355039
It is normal and it is part of the test!
-------------
Test LweSymDecrypt :
----------------------
Test LweSymDecryptT: trial 364
1840700269 =? 1227133513 Error!!!
----------------------


-------------------------
TEST Operations TLwe :
-------------------------
Test tLweAddTo Trial : 1
0 =? 6 error!!!
6 =? 5 error!!!
1 =? 2 error!!!
3 =? 4 error!!!
2 =? 1 error!!!
0 =? 6 error!!!
5 =? 6 error!!!
3 =? 4 error!!!
0 =? 1 error!!!
0 =? 6 error!!!
6 =? 5 error!!!
3 =? 2 error!!!
0.0008
----------------------
Test tLweSubTo Trial : 1
4 =? 5 error!!!
5 =? 4 error!!!
3 =? 2 error!!!
5 =? 6 error!!!
3 =? 2 error!!!
6 =? 0 error!!!
5 =? 4 error!!!
3 =? 4 error!!!
0 =? 1 error!!!
0.0008
----------------------
Test tLweAddMulTo Trial :1
0 =? 6 error!!!
6 =? 5 error!!!
1 =? 2 error!!!
3 =? 4 error!!!
2 =? 1 error!!!
0 =? 6 error!!!
5 =? 6 error!!!
3 =? 4 error!!!
0 =? 1 error!!!
0 =? 6 error!!!
6 =? 5 error!!!
3 =? 2 error!!!
0.0008
----------------------
Test tLweSubMulTo Trial :1
4 =? 5 error!!!
5 =? 4 error!!!
3 =? 2 error!!!
5 =? 6 error!!!
3 =? 2 error!!!
6 =? 0 error!!!
5 =? 4 error!!!
3 =? 4 error!!!
0 =? 1 error!!!
0.0008
----------------------


-----------------------------------------------
TEST Operations TLwe with Torus32 messages :
-----------------------------------------------
Test tLweAddTo Trial : 42
1 =? 2 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 42
1 =? 2 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 44
1 =? 0 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 44
1 =? 0 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 56
5 =? 6 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 56
5 =? 6 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 63
6 =? 0 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 63
6 =? 0 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 90
4 =? 5 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 90
4 =? 5 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 172
0 =? 1 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 172
0 =? 1 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 240
6 =? 5 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 240
6 =? 5 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 253
5 =? 6 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 253
5 =? 6 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 286
3 =? 4 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 286
3 =? 4 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 404
5 =? 4 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 404
5 =? 4 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 421
3 =? 4 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 421
3 =? 4 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 433
4 =? 5 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 433
4 =? 5 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 496
3 =? 2 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 496
3 =? 2 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 519
2 =? 3 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 519
2 =? 3 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 547
3 =? 4 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 547
3 =? 4 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 591
5 =? 6 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 591
5 =? 6 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 627
6 =? 0 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 627
6 =? 0 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 635
2 =? 1 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 635
2 =? 1 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 645
6 =? 5 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 645
6 =? 5 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 675
5 =? 6 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 675
5 =? 6 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 705
6 =? 0 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 705
6 =? 0 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 749
4 =? 3 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 749
4 =? 3 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 808
1 =? 0 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 808
1 =? 0 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 823
2 =? 3 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 823
2 =? 3 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 846
2 =? 3 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 846
2 =? 3 Error!!!
0.0008
----------------------
Test tLweAddTo Trial : 863
4 =? 3 Error!!!
0.0008
----------------------
Test tLweAddMulTo Trial : 863
4 =? 3 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 904
6 =? 5 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 904
6 =? 5 Error!!!
0.0008
----------------------
Test tLweSubTo Trial : 939
5 =? 4 Error!!!
0.0008
----------------------
Test tLweSubMulTo Trial : 939
5 =? 4 Error!!!
0.0008
----------------------


[qwe@localhost test]$ ./unittests-fftw
Running main() from /home/qwe/Develop/googletest-main/googletest/src/gtest_main.cc
[==========] Running 115 tests from 24 test suites.
[----------] Global test environment set-up.
[----------] 5 tests from ArithmeticTest
[ RUN      ] ArithmeticTest.gaussian32
[       OK ] ArithmeticTest.gaussian32 (0 ms)
[ RUN      ] ArithmeticTest.dtot32
[       OK ] ArithmeticTest.dtot32 (0 ms)
[ RUN      ] ArithmeticTest.approxPhase
[       OK ] ArithmeticTest.approxPhase (0 ms)
[ RUN      ] ArithmeticTest.modSwitchFromTorus32
[       OK ] ArithmeticTest.modSwitchFromTorus32 (0 ms)
[ RUN      ] ArithmeticTest.modSwitchToTorus32
[       OK ] ArithmeticTest.modSwitchToTorus32 (0 ms)
[----------] 5 tests from ArithmeticTest (0 ms total)

[----------] 8 tests from LweTest
[ RUN      ] LweTest.lweKeyGen
[       OK ] LweTest.lweKeyGen (0 ms)
[ RUN      ] LweTest.lweSymEncryptPhaseDecrypt
[       OK ] LweTest.lweSymEncryptPhaseDecrypt (7 ms)
[ RUN      ] LweTest.lweClear
[       OK ] LweTest.lweClear (0 ms)
[ RUN      ] LweTest.lweNoiselessTrivial
[       OK ] LweTest.lweNoiselessTrivial (0 ms)
[ RUN      ] LweTest.lweAddTo
[       OK ] LweTest.lweAddTo (0 ms)
[ RUN      ] LweTest.lweSubTo
[       OK ] LweTest.lweSubTo (0 ms)
[ RUN      ] LweTest.lweAddMulTo
[       OK ] LweTest.lweAddMulTo (0 ms)
[ RUN      ] LweTest.lweSubMulTo
[       OK ] LweTest.lweSubMulTo (0 ms)
[----------] 8 tests from LweTest (9 ms total)

[----------] 19 tests from PolynomialTest
[ RUN      ] PolynomialTest.torusPolynomialUniform
[       OK ] PolynomialTest.torusPolynomialUniform (4 ms)
[ RUN      ] PolynomialTest.torusPolynomialClear
[       OK ] PolynomialTest.torusPolynomialClear (0 ms)
[ RUN      ] PolynomialTest.torusPolynomialCopy
[       OK ] PolynomialTest.torusPolynomialCopy (0 ms)
[ RUN      ] PolynomialTest.torusPolynomialAdd
[       OK ] PolynomialTest.torusPolynomialAdd (0 ms)
[ RUN      ] PolynomialTest.torusPolynomialAddTo
[       OK ] PolynomialTest.torusPolynomialAddTo (0 ms)
[ RUN      ] PolynomialTest.torusPolynomialSub
[       OK ] PolynomialTest.torusPolynomialSub (0 ms)
[ RUN      ] PolynomialTest.torusPolynomialSubTo
[       OK ] PolynomialTest.torusPolynomialSubTo (0 ms)
[ RUN      ] PolynomialTest.torusPolynomialAddMulZ
[       OK ] PolynomialTest.torusPolynomialAddMulZ (0 ms)
[ RUN      ] PolynomialTest.torusPolynomialAddMulZTo
[       OK ] PolynomialTest.torusPolynomialAddMulZTo (0 ms)
[ RUN      ] PolynomialTest.torusPolynomialSubMulZ
[       OK ] PolynomialTest.torusPolynomialSubMulZ (0 ms)
[ RUN      ] PolynomialTest.torusPolynomialSubMulZTo
[       OK ] PolynomialTest.torusPolynomialSubMulZTo (0 ms)
[ RUN      ] PolynomialTest.torusPolynomialMulByXai
[       OK ] PolynomialTest.torusPolynomialMulByXai (25 ms)
[ RUN      ] PolynomialTest.intPolynomialMulByXaiMinusOne
[       OK ] PolynomialTest.intPolynomialMulByXaiMinusOne (31 ms)
[ RUN      ] PolynomialTest.torusPolynomialMulByXaiMinusOne
[       OK ] PolynomialTest.torusPolynomialMulByXaiMinusOne (20 ms)
[ RUN      ] PolynomialTest.intPolynomialNormSq2
[       OK ] PolynomialTest.intPolynomialNormSq2 (12 ms)
[ RUN      ] PolynomialTest.torusPolynomialMultNaive
[       OK ] PolynomialTest.torusPolynomialMultNaive (154 ms)
[ RUN      ] PolynomialTest.torusPolynomialMultKaratsuba
[       OK ] PolynomialTest.torusPolynomialMultKaratsuba (139 ms)
[ RUN      ] PolynomialTest.torusPolynomialAddMulRKaratsuba
[       OK ] PolynomialTest.torusPolynomialAddMulRKaratsuba (140 ms)
[ RUN      ] PolynomialTest.torusPolynomialSubMulRKaratsuba
[       OK ] PolynomialTest.torusPolynomialSubMulRKaratsuba (137 ms)
[----------] 19 tests from PolynomialTest (673 ms total)

[----------] 12 tests from TLweTest
[ RUN      ] TLweTest.tLweKeyGen
[       OK ] TLweTest.tLweKeyGen (0 ms)
[ RUN      ] TLweTest.tLweSymEncryptPhaseDecryptT
[       OK ] TLweTest.tLweSymEncryptPhaseDecryptT (8 ms)
[ RUN      ] TLweTest.tLweSymEncryptPhaseDecrypt
[       OK ] TLweTest.tLweSymEncryptPhaseDecrypt (10 ms)
[ RUN      ] TLweTest.tLweClear
[       OK ] TLweTest.tLweClear (0 ms)
[ RUN      ] TLweTest.tLweCopy
[       OK ] TLweTest.tLweCopy (0 ms)
[ RUN      ] TLweTest.tLweNoiselessTrivial
[       OK ] TLweTest.tLweNoiselessTrivial (0 ms)
[ RUN      ] TLweTest.tLweAddTo
[       OK ] TLweTest.tLweAddTo (1 ms)
[ RUN      ] TLweTest.tLweSubTo
[       OK ] TLweTest.tLweSubTo (1 ms)
[ RUN      ] TLweTest.tLweAddMulTo
[       OK ] TLweTest.tLweAddMulTo (1 ms)
[ RUN      ] TLweTest.tLweSubMulTo
[       OK ] TLweTest.tLweSubMulTo (1 ms)
[ RUN      ] TLweTest.tLweAddTTo
[       OK ] TLweTest.tLweAddTTo (0 ms)
[ RUN      ] TLweTest.tLweAddRTTo
[       OK ] TLweTest.tLweAddRTTo (0 ms)
[----------] 12 tests from TLweTest (29 ms total)

[----------] 6 tests from TGswTest
[ RUN      ] TGswTest.tGswKeyGen
[       OK ] TGswTest.tGswKeyGen (0 ms)
[ RUN      ] TGswTest.tGswClear
[       OK ] TGswTest.tGswClear (0 ms)
[ RUN      ] TGswTest.tGswEncryptZero
[       OK ] TGswTest.tGswEncryptZero (0 ms)
[ RUN      ] TGswTest.tGswExternProduct
[       OK ] TGswTest.tGswExternProduct (38 ms)
[ RUN      ] TGswTest.tGswMulByXaiMinusOne
[       OK ] TGswTest.tGswMulByXaiMinusOne (31 ms)
[ RUN      ] TGswTest.tGswExternMulToTLwe
[       OK ] TGswTest.tGswExternMulToTLwe (43 ms)
[----------] 6 tests from TGswTest (113 ms total)

[----------] 3 tests from TGswFakeTest
[ RUN      ] TGswFakeTest.tGswSymEncrypt
[       OK ] TGswFakeTest.tGswSymEncrypt (0 ms)
[ RUN      ] TGswFakeTest.tGswSymEncryptInt
[       OK ] TGswFakeTest.tGswSymEncryptInt (0 ms)
[ RUN      ] TGswFakeTest.tGswNoiselessTrivial
[       OK ] TGswFakeTest.tGswNoiselessTrivial (0 ms)
[----------] 3 tests from TGswFakeTest (0 ms total)

[----------] 5 tests from TGswDirectTest
[ RUN      ] TGswDirectTest.tGswAddH
[       OK ] TGswDirectTest.tGswAddH (9 ms)
[ RUN      ] TGswDirectTest.tGswAddMuH
[       OK ] TGswDirectTest.tGswAddMuH (7 ms)
[ RUN      ] TGswDirectTest.tGswAddMuIntH
[       OK ] TGswDirectTest.tGswAddMuIntH (10 ms)
[ RUN      ] TGswDirectTest.tGswTorus32PolynomialDecompH
[       OK ] TGswDirectTest.tGswTorus32PolynomialDecompH (0 ms)
[ RUN      ] TGswDirectTest.tGswTLweDecompH
[       OK ] TGswDirectTest.tGswTLweDecompH (0 ms)
[----------] 5 tests from TGswDirectTest (28 ms total)

[----------] 4 tests from TLweFFTTest
[ RUN      ] TLweFFTTest.tLweToFFTConvert
[       OK ] TLweFFTTest.tLweToFFTConvert (0 ms)
[ RUN      ] TLweFFTTest.tLweFromFFTConvert
[       OK ] TLweFFTTest.tLweFromFFTConvert (0 ms)
[ RUN      ] TLweFFTTest.tLweFFTClear
[       OK ] TLweFFTTest.tLweFFTClear (0 ms)
[ RUN      ] TLweFFTTest.tLweAddMulRTo
[       OK ] TLweFFTTest.tLweAddMulRTo (0 ms)
[----------] 4 tests from TLweFFTTest (1 ms total)

[----------] 6 tests from TGswFFTTest
[ RUN      ] TGswFFTTest.tGswToFFTConvert
[       OK ] TGswFFTTest.tGswToFFTConvert (1 ms)
[ RUN      ] TGswFFTTest.tGswFromFFTConvert
[       OK ] TGswFFTTest.tGswFromFFTConvert (2 ms)
[ RUN      ] TGswFFTTest.tGswFFTAddH
[       OK ] TGswFFTTest.tGswFFTAddH (0 ms)
[ RUN      ] TGswFFTTest.tGswFFTClear
[       OK ] TGswFFTTest.tGswFFTClear (1 ms)
[ RUN      ] TGswFFTTest.tGswFFTExternMulToTLwe
[       OK ] TGswFFTTest.tGswFFTExternMulToTLwe (42 ms)
[ RUN      ] TGswFFTTest.tGswFFTMulByXaiMinusOne
[       OK ] TGswFFTTest.tGswFFTMulByXaiMinusOne (0 ms)
[----------] 6 tests from TGswFFTTest (48 ms total)

[----------] 2 tests from LweKeySwitchTest
[ RUN      ] LweKeySwitchTest.lweCreateKeySwitchKey_fromArray
[       OK ] LweKeySwitchTest.lweCreateKeySwitchKey_fromArray (30 ms)
[ RUN      ] LweKeySwitchTest.lweKeySwitchTranslate_fromArray
[       OK ] LweKeySwitchTest.lweKeySwitchTranslate_fromArray (26 ms)
[----------] 2 tests from LweKeySwitchTest (57 ms total)

[----------] 1 test from TfheBlindRotateTest
[ RUN      ] TfheBlindRotateTest.tfheBlindRotateTest
[       OK ] TfheBlindRotateTest.tfheBlindRotateTest (250 ms)
[----------] 1 test from TfheBlindRotateTest (250 ms total)

[----------] 1 test from TfheBlindRotateAndExtractTest
[ RUN      ] TfheBlindRotateAndExtractTest.tfheBlindRotateAndExtractTest
[       OK ] TfheBlindRotateAndExtractTest.tfheBlindRotateAndExtractTest (1 ms)
[----------] 1 test from TfheBlindRotateAndExtractTest (1 ms total)

[----------] 1 test from TfheBootstrapWoKSTest
[ RUN      ] TfheBootstrapWoKSTest.tfheBootstrapWoKSTest
[       OK ] TfheBootstrapWoKSTest.tfheBootstrapWoKSTest (3 ms)
[----------] 1 test from TfheBootstrapWoKSTest (3 ms total)

[----------] 1 test from TfheBootstrapTest
[ RUN      ] TfheBootstrapTest.tfheBootstrapTest
[       OK ] TfheBootstrapTest.tfheBootstrapTest (0 ms)
[----------] 1 test from TfheBootstrapTest (0 ms total)

[----------] 1 test from TfheCreateBootstrapKeyTest
[ RUN      ] TfheCreateBootstrapKeyTest.createBootstrappingKeyTest
[       OK ] TfheCreateBootstrapKeyTest.createBootstrappingKeyTest (1 ms)
[----------] 1 test from TfheCreateBootstrapKeyTest (1 ms total)

[----------] 1 test from TfheBlindRotateFFTTest
[ RUN      ] TfheBlindRotateFFTTest.tfheBlindRotateFFTTest
[       OK ] TfheBlindRotateFFTTest.tfheBlindRotateFFTTest (205 ms)
[----------] 1 test from TfheBlindRotateFFTTest (205 ms total)

[----------] 1 test from TfheBlindRotateAndExtractFFTTest
[ RUN      ] TfheBlindRotateAndExtractFFTTest.tfheBlindRotateAndExtractFFTTest
[       OK ] TfheBlindRotateAndExtractFFTTest.tfheBlindRotateAndExtractFFTTest (2 ms)
[----------] 1 test from TfheBlindRotateAndExtractFFTTest (2 ms total)

[----------] 1 test from TfheBootstrapWoKSFFTTest
[ RUN      ] TfheBootstrapWoKSFFTTest.tfheBootstrapWoKSFFTTest
[       OK ] TfheBootstrapWoKSFFTTest.tfheBootstrapWoKSFFTTest (2 ms)
[----------] 1 test from TfheBootstrapWoKSFFTTest (2 ms total)

[----------] 1 test from TfheBootstrapFFTTest
[ RUN      ] TfheBootstrapFFTTest.tfheBootstrapFFTTest
[       OK ] TfheBootstrapFFTTest.tfheBootstrapFFTTest (0 ms)
[----------] 1 test from TfheBootstrapFFTTest (0 ms total)

[----------] 1 test from TfheInitLweBootstrappingKeyFFTTest
[ RUN      ] TfheInitLweBootstrappingKeyFFTTest.tfheInitLweBootstrappingKeyFFTTest
[       OK ] TfheInitLweBootstrappingKeyFFTTest.tfheInitLweBootstrappingKeyFFTTest (3 ms)
[----------] 1 test from TfheInitLweBootstrappingKeyFFTTest (3 ms total)

[----------] 12 tests from IOTest
[ RUN      ] IOTest.LweParamsIO
-----BEGIN LWEPARAMS-----
alpha_max: 0.30000000
alpha_min: 0.10000000
n: 500
-----END LWEPARAMS-----
-----BEGIN LWEPARAMS-----
alpha_max: 0.30000000
alpha_min: 0.10000000
n: 120
-----END LWEPARAMS-----
[       OK ] IOTest.LweParamsIO (1 ms)
[ RUN      ] IOTest.TLweParamsIO
-----BEGIN TLWEPARAMS-----
N: 1024
alpha_max: 0.30000000
alpha_min: 0.10000000
k: 1
-----END TLWEPARAMS-----
-----BEGIN TLWEPARAMS-----
N: 128
alpha_max: 0.30000000
alpha_min: 0.10000000
k: 2
-----END TLWEPARAMS-----
[       OK ] IOTest.TLweParamsIO (0 ms)
[ RUN      ] IOTest.TGswParamsIO
-----BEGIN TLWEPARAMS-----
N: 1024
alpha_max: 0.30000000
alpha_min: 0.10000000
k: 1
-----END TLWEPARAMS-----
-----BEGIN TGSWPARAMS-----
Bgbit: 15
l: 3
-----END TGSWPARAMS-----
-----BEGIN TLWEPARAMS-----
N: 128
alpha_max: 0.30000000
alpha_min: 0.10000000
k: 2
-----END TLWEPARAMS-----
-----BEGIN TGSWPARAMS-----
Bgbit: 4
l: 7
-----END TGSWPARAMS-----
[       OK ] IOTest.TGswParamsIO (0 ms)
[ RUN      ] IOTest.LweKeyIO
[       OK ] IOTest.LweKeyIO (0 ms)
[ RUN      ] IOTest.TLweKeyIO
[       OK ] IOTest.TLweKeyIO (0 ms)
[ RUN      ] IOTest.TGswKeyIO
[       OK ] IOTest.TGswKeyIO (0 ms)
[ RUN      ] IOTest.LweSampleIO
[       OK ] IOTest.LweSampleIO (0 ms)
[ RUN      ] IOTest.TLweSampleIO
[       OK ] IOTest.TLweSampleIO (0 ms)
[ RUN      ] IOTest.TGswSampleIO
[       OK ] IOTest.TGswSampleIO (1 ms)
[ RUN      ] IOTest.LweKeySwitchKeyIO
[       OK ] IOTest.LweKeySwitchKeyIO (20 ms)
[ RUN      ] IOTest.LweBootstrappingKeyIO
[       OK ] IOTest.LweBootstrappingKeyIO (34 ms)
[ RUN      ] IOTest.TFheGateBootstrappingParameterSetIO
-----BEGIN GATEBOOTSPARAMS-----
ks_basebit: 2
ks_t: 6
-----END GATEBOOTSPARAMS-----
-----BEGIN LWEPARAMS-----
alpha_max: 0.30000000
alpha_min: 0.10000000
n: 120
-----END LWEPARAMS-----
-----BEGIN TLWEPARAMS-----
N: 128
alpha_max: 0.30000000
alpha_min: 0.10000000
k: 2
-----END TLWEPARAMS-----
-----BEGIN TGSWPARAMS-----
Bgbit: 4
l: 7
-----END TGSWPARAMS-----
[       OK ] IOTest.TFheGateBootstrappingParameterSetIO (0 ms)
[----------] 12 tests from IOTest (58 ms total)

[----------] 2 tests from IOTest2
[ RUN      ] IOTest2.TFheGateBootstrappingCloudKeySetIO
[       OK ] IOTest2.TFheGateBootstrappingCloudKeySetIO (30 ms)
[ RUN      ] IOTest2.TFheGateBootstrappingSecretKeySetIO
[       OK ] IOTest2.TFheGateBootstrappingSecretKeySetIO (29 ms)
[----------] 2 tests from IOTest2 (60 ms total)

[----------] 8 tests from LagrangeHalfcTest
[ RUN      ] LagrangeHalfcTest.fftIsBijective
[       OK ] LagrangeHalfcTest.fftIsBijective (1 ms)
[ RUN      ] LagrangeHalfcTest.LagrangeHalfCPolynomialClear
[       OK ] LagrangeHalfcTest.LagrangeHalfCPolynomialClear (0 ms)
[ RUN      ] LagrangeHalfcTest.LagrangeHalfCPolynomialSetTorusConstant
[       OK ] LagrangeHalfcTest.LagrangeHalfCPolynomialSetTorusConstant (0 ms)
[ RUN      ] LagrangeHalfcTest.LagrangeHalfCPolynomialAddTorusConstant
[       OK ] LagrangeHalfcTest.LagrangeHalfCPolynomialAddTorusConstant (0 ms)
[ RUN      ] LagrangeHalfcTest.torusPolynomialMultFFT
[       OK ] LagrangeHalfcTest.torusPolynomialMultFFT (2 ms)
[ RUN      ] LagrangeHalfcTest.torusPolynomialAddMulRFFT
[       OK ] LagrangeHalfcTest.torusPolynomialAddMulRFFT (3 ms)
[ RUN      ] LagrangeHalfcTest.torusPolynomialSubMulRFFT
[       OK ] LagrangeHalfcTest.torusPolynomialSubMulRFFT (2 ms)
[ RUN      ] LagrangeHalfcTest.LagrangeHalfCPolynomialAddTo
[       OK ] LagrangeHalfcTest.LagrangeHalfCPolynomialAddTo (3 ms)
[----------] 8 tests from LagrangeHalfcTest (13 ms total)

[----------] 13 tests from BootsGateTest
[ RUN      ] BootsGateTest.NandTest
[       OK ] BootsGateTest.NandTest (0 ms)
[ RUN      ] BootsGateTest.AndTest
[       OK ] BootsGateTest.AndTest (0 ms)
[ RUN      ] BootsGateTest.AndNYTest
[       OK ] BootsGateTest.AndNYTest (0 ms)
[ RUN      ] BootsGateTest.AndYNTest
[       OK ] BootsGateTest.AndYNTest (0 ms)
[ RUN      ] BootsGateTest.NorTest
[       OK ] BootsGateTest.NorTest (0 ms)
[ RUN      ] BootsGateTest.OrTest
[       OK ] BootsGateTest.OrTest (0 ms)
[ RUN      ] BootsGateTest.OrNYTest
[       OK ] BootsGateTest.OrNYTest (0 ms)
[ RUN      ] BootsGateTest.OrYNTest
[       OK ] BootsGateTest.OrYNTest (0 ms)
[ RUN      ] BootsGateTest.XorTest
[       OK ] BootsGateTest.XorTest (0 ms)
[ RUN      ] BootsGateTest.XnorTest
[       OK ] BootsGateTest.XnorTest (0 ms)
[ RUN      ] BootsGateTest.NotTest
[       OK ] BootsGateTest.NotTest (0 ms)
[ RUN      ] BootsGateTest.CopyTest
[       OK ] BootsGateTest.CopyTest (0 ms)
[ RUN      ] BootsGateTest.MuxTest
[       OK ] BootsGateTest.MuxTest (0 ms)
[----------] 13 tests from BootsGateTest (0 ms total)

[----------] Global test environment tear-down
[==========] 115 tests from 24 test suites ran. (1565 ms total)
[  PASSED  ] 115 tests.
[qwe@localhost test]$ 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++












