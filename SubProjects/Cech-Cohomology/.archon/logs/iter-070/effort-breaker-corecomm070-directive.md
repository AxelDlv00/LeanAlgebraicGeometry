# effort-breaker directive — slug corecomm070

## Target
`lem:coreIso_comm` in `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(Lean: `AlgebraicGeometry.coreIso_comm`, `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
line ~1468, the file's highest-effort open sorry, effort 2242). Its deps
(`lem:coreIso_obj_iso`, `lem:coverInterOpen_inf_distrib`, `lem:section_cech_objd_apply`,
`lem:section_cech_product_equiv`) are all DONE — it is the live frontier bottleneck.

## Granularity
Fine — one mathematical claim per sub-lemma. A prior coarser break (iter-067: the
lattice/objIso/comm 3-chain) landed the first two; the remaining `coreIso_comm` piece stalled with a
precise recorded stuck point. Break along that stuck point.

## Proof structure (cut at these two seams)

The square to prove: \((\mathrm{objIso}\,p).\mathrm{hom} \cdot d^p_{\check{\mathcal C}(\mathcal U')}
= d^p_{(G_V\circ\Psi)\check{\mathcal C}(\mathcal U)} \cdot (\mathrm{objIso}\,(p+1)).\mathrm{hom}\),
where both differentials are alternating coface sums (`AlternatingCofaceMapComplex.objD`,
\(d = \sum_k (-1)^k \delta_k\)).

**Seam S1 — the per-coface square (the mathematical content).** For each coface index
\(k \le p+1\): the evaluated push–pull coface matches the section-Čech face restriction at \(k\),
\[(\mathrm{objIso}\,p).\mathrm{hom} \cdot \delta^{\mathrm{sec}}_k
 = G_V(\Psi(\delta^{\mathrm{nerve}}_k)) \cdot (\mathrm{objIso}\,(p+1)).\mathrm{hom},\]
both sides being induced by the SAME inclusion of intersection opens
\(\bigl(\bigwedge_j (\mathrm{coverOpen}\,\mathcal U\,((\sigma\circ\delta^k)\,j)\bigr) \sqcap V
\le \bigl(\bigwedge_j \mathrm{coverOpen}\,\mathcal U\,(\sigma'\,j)\bigr) \sqcap V\). Route: check on
elements through `sectionCechProductEquiv` (lem:section_cech_product_equiv); per product leg \(\sigma\)
the LHS is the face restriction `sectionCechFaceRestr` and the RHS unwinds through the leg structure of
`objIso` — `pushPull_eval_prod_iso` (Stub 4) factoring through `pushPull_sigma_iso` (Stub 2),
`PreservesProduct.iso`, and `pushPull_leg_sections` (Stub 3) — to the restriction of \(\mathcal F\)
along the same open inclusion. If this single claim is still large, ITERATE: split off the
"one product leg" naturality (the projection of the RHS onto the \(\sigma\)-component equals the
\(\mathcal F\)-restriction along the face inclusion) as its own sub-lemma.

**Seam S2 — the alternating-sum bookkeeping (the recorded Lean blocker).** Given S1 per coface,
sum: push the additive functors \(\Psi\), \(G_V\) and the leading/trailing compositions through
\(\sum_k (-1)^k \delta_k\). The iter-067 prover recorded that the categorical sum route
(`Preadditive.comp_sum`/`Functor.map_sum`) clashes with the bundled `AddCommGrpCat`-hom representation
of `objD`; the recommended shape is ELEMENTWISE — state S2 as an identity of group elements via
`sectionCech_objD_apply` (lem:section_cech_objd_apply), so both sides become pointwise finite sums
\(\sum_k (-1)^k\,(\text{restriction})\) and S1 is applied summand-by-summand under `Finset.sum_congr`.

## Output
2–3 `\uses`-chained sub-lemma blocks (statement + informal proof each), with fresh `\label`s
(suggest `lem:coreIso_comm_coface`, `lem:coreIso_comm_sum` — adjust as natural) and fresh `\lean{}`
names you must verify are FREE in the project (e.g. `AlgebraicGeometry.coreIso_comm_coface`);
rewrite `lem:coreIso_comm`'s proof sketch to consume them. Statement-level `\uses` discipline
(leandag reads statement `\uses` only). NO `\leanok`.
