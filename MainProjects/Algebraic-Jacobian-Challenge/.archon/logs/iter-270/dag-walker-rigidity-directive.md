# DAG Walker Directive

## Slug
rigidity

## Seed
prop:rigidity_genus0_curve_to_AV

## Strategy context
The genus-0 arm of the Jacobian witness (`def:genusZeroWitness`) consumes the
characteristic-free rigidity keystone `prop:rigidity_genus0_curve_to_AV`
(AbelianVarietyRigidity.tex): a morphism from a smooth proper geometrically
irreducible genus-0 curve into a smooth proper geometrically irreducible group
scheme over an algebraically closed field is constant. Its proof is the Milne
§I.3 rigidity chain (Rigidity Lemma + additivity + rational-map extension),
cube-free. Supporting it: the scheme-level rigidity lemma family
(`thm:rigidity_lemma`, the `eqOn`/`eqAt` decomposition lemmas in
AbelianVarietyRigidity.tex), the over-k̄ fallback `thm:rigidity_over_kbar`
(RigidityKbar.tex) with its shared cotangent-vanishing pile and the GrpObj
cotangent/Lie-algebra lemmas, the base-field rigidity `thm:GrpObj_eq_of_eqOnOpen`
(Rigidity.tex), the GrpObj cotangent bridge (AlgebraicJacobian_Cotangent_GrpObj.tex),
the Kähler-differential facts (Differentials.tex), and the genus-0 base objects
(Genus0BaseObjects_Cross01Substrate.tex). These chapters are heavily isolated
(~70 nodes total) — the maths is written, the `\uses{}` edges are missing.

## Depth / scope
**Your write domain is ONLY: AbelianVarietyRigidity.tex, RigidityKbar.tex,
Rigidity.tex, AlgebraicJacobian_Cotangent_GrpObj.tex, Differentials.tex,
Genus0BaseObjects_Cross01Substrate.tex.** Three parallel walkers own the other
regions — do NOT edit them.

Walk UP from `prop:rigidity_genus0_curve_to_AV` (and also make the
`thm:rigidity_over_kbar` and `thm:rigidity_lemma` cones complete, since they are
in your region) and:

1. For each isolated node in your chapters (use `archon dag-query ancestors` on
   the seeds and `leandag show isolated --json` filtered to your chapters), read
   its statement/proof and add the `\uses{}` edges its proof actually invokes,
   intra- and inter-chapter within your region.
2. Wire the Milne rigidity chain: `prop:rigidity_genus0_curve_to_AV` `\uses` the
   rigidity-lemma decomposition (`thm:rigidity_lemma`,
   `lem:rigidity_eqOn_dense_open`, `lem:morphism_eq_of_eqAt_closedPoints`,
   `lem:rigidity_eqAt_closedPoint_of_proper_into_affine`, the additivity /
   rational-map-extension pieces) and the genus-0 / base-object facts it relies
   on.
3. Wire the over-k̄ pile: `thm:rigidity_over_kbar` `\uses` the shared
   cotangent-vanishing pieces (i)+(ii)+(iii), the GrpObj cotangent lemmas
   (`lem:GrpObj_cotangentSpace`, `lem:GrpObj_cotangent_bridge`,
   `lem:GrpObj_lieAlgebra_finrank`, `lem:GrpObj_shearMulRight`,
   `lem:GrpObj_mulRight_globalises`, the `lem:GrpObj_omega_*` family) and the
   Differentials chapter results these consume.
4. Where the cone bottoms out at a Mathlib result and there is no project block,
   author a Mathlib dependency anchor (`\mathlibok` + `\lean{<real decl>}` +
   `\textit{Provided by Mathlib.}`) ONLY if you can name the genuine Mathlib
   declaration; otherwise report it.

**Boundary rule:** `def:genusZeroWitness` (Jacobian.tex) is owned by the
Backbone walker, which adds the edge down to `prop:rigidity_genus0_curve_to_AV`.
You do NOT edit Jacobian.tex. If your cone references a Picard/Albanese label
(e.g. an abelian-variety fact also used by Route A), add the `\uses{}` edge and
stop at that boundary; record the handoff.

For any node in your chapters with a real statement but no `\lean{}` and not a
`\begin{remark}`, add a placeholder `\lean{AlgebraicGeometry.TODO.<name>}`. Note:
the RigidityKbar `lem:GrpObj_omega_*` family is intentionally pin-deferred until
route A.3/A.4 opens — if a block already carries an explanatory note that it has
no Lean target yet, give it a placeholder pin rather than leaving it unpinned.

Do NOT add `\leanok`. Do NOT invent new mathematics; transcribe dependencies. A
genuinely proof-less ∞ node goes under "Could not complete".

## References
- `references/abelian-varieties.md` (Milne, Rigidity Theorem 1.1 §I.1; Thm 3.2 +
  Prop 3.10 §I.3; rigidity chain). Cite verbatim from the local file.
- `references/mumford-abelian-varieties.md` (Mumford §4 rigidity, if needed).
  Quote only from the downloaded source files; never from memory.
