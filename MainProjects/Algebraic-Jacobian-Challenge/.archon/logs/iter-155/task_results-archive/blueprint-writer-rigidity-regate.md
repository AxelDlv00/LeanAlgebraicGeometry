# Blueprint Writer Report

## Slug
rigidity-regate

## Status
COMPLETE

All six required changes were applied to `blueprint/src/chapters/RigidityKbar.tex`.
The protected, axiom-clean PROOF blocks (KDM, `constants_integral_over_base_field`,
`chart_algebra_df_zero_factors_through_constant_on_chart`) were left untouched.

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Changes Made

1. **Added `% archon:covers` line** (top, after `\label{chap:RigidityKbar}`):
   `% archon:covers RigidityKbar.lean Cotangent/ChartAlgebra.lean`. (No prior
   chapter used this directive; matched the literal form the directive specified.)

2. **Re-scoped `thm:rigidity_over_kbar` as a gated NAMED GAP** — replaced the old
   line-12 "gated on a Mathlib pile … body is closed iter-128+" paragraph with a
   thorough honest disclosure modeled on `Jacobian.tex`'s `thm:nonempty_jacobianWitness`
   style: states the body is a held `sorry`, gives the global-sections decomposition
   `df = 0 ⟺ H^0(C,Ω_C)=0` (given the gap-(i) trivialisation), itemises **gap (i)**
   (excised `mulRight_globalises_cotangent`, ~800–1500 LOC, GroupLieAlgebra doesn't
   port) and **gap (ii)** (Serre duality `H^0(C,Ω_C)=0`, ~3000–8000 LOC), states the
   chart-algebra envelope supplies only the converse, and presents **route (a)** and
   **route (b)** committing to neither.

3. **Corrected the false "chart-algebra avoids Serre duality" framing** in every
   location the directive named:
   - **Proof decomposition** (`sec:RigidityKbar_proof_decomposition`): added a gating
     header to the section intro; flagged **C.2.c** as naming no present Mathlib infra
     (image-of-proper-map closed/irreducible, scheme dimension); rewrote **C.2.d** to
     state the reduction to `df=0`, the `df=0 ⟺ H^0(C,Ω_C)=0` equivalence, and the two
     gated routes (a)/(b); marked C.2.b–C.2.e as the eventual recipe for a gated gap.
   - **Piece (iv)** (`sec:RigidityKbar_shared_pile`): retitled to "DEFERRED named gap,
     ON the C.2.d critical path (iter-155 correction)"; explicitly retracted the prior
     "NOT used by C.2.d" / "C.2.d does NOT depend on piece (iv)" claims with the
     global-sections argument.
   - **"No-Serre-duality layer"** (β three-layer chain): retitled to
     "Constancy-from-`df=0` layer (the converse only)"; retracted "replaces … route /
     eliminating piece (iv) as a critical-path dependency"; clarified it delivers only
     the converse and that `H^0(C,Ω_C)=0` is needed to *establish* `df=0`.
   - **Chart-algebra envelope summary**: retracted "replaces … the Serre-duality
     cohomology vanishing (piece (iv))"; kept the (iii)-Frobenius replacement claim
     (still true) but flagged piece (iv) as not replaced.
   - **Iter-144 disposition bullet** (status correction): noted
     `mulRight_globalises_cotangent` was **EXCISED iter-145** (design template only,
     not a present decl) — the old "remain in-tree (sorry-bodied)" claim was stale and
     contradicted the ext-block fix.
   - **Q3 absorption subsection intro**: appended an iter-155 scope clarification
     distinguishing the closed converse build (genuinely Serre-duality-free *as a
     hypothesis consumer*) from the gated `df=0` production (needs piece (iv)).
   - **Per-piece build-order paragraph** (end of pile section): corrected "Piece (iv)
     is parked, not built" to flag piece (iv) as on the keystone critical path under
     route (a).

4. **Fixed `lem:Scheme_Over_ext_of_diff_zero`** (this block is NOT in the protected
   set; the directive explicitly asked for it):
   - Added a visible **statement-vs-Lean signature divergence** paragraph: the present
     Lean decl is the thin `ext_of_eqOnOpen` wrapper (`[IsSeparated A.hom]` +
     `[IsReduced C.left]` + `[GeometricallyIrreducible C.hom]`, consumes `eqOnOpen U`,
     no `df=dg`/genus-0/group-scheme hyps); the substantive `df=dg` form is a gated
     refinement, inert until `df=0` is producible.
   - Marked proof Steps 1–3 as the gated closing-glue recipe (not a present obligation).
   - **Removed the load-bearing `\cref{lem:GrpObj_mulRight_globalises}` reference** in
     Step 1 (excised iter-145); replaced with plain functorial transport + a `% iter-155`
     comment recording the excision.
   - Added the **cheap final-glue note**: `Submodule.linearMap_eq_zero_iff_of_span_eq_top`
     [verified] for the `df=0` production direction (~5–20 LOC, presupposes both gaps).

5. **Pruned the stale KDM statement-block `\uses{}`** (was
   `\uses{lem:chart_algebra_isPushout_of_affine_product,
   lem:KaehlerDifferential_constants_in_chart_of_proper_curve}`) — the live (FT.1)–(FT.3)
   route consumes neither; replaced with an explanatory `% iter-155` comment. **Demoted
   `lem:KaehlerDifferential_constants_in_chart_of_proper_curve`** to an off-path record
   (title suffix + `% NOTE (iter-155)` + visible "Iter-155 disposition" paragraph),
   mirroring the iter-152 DESCOPED-note language used elsewhere. The KDM/constants/
   df_zero_factors PROOF blocks were not otherwise touched.

## Cross-references introduced
- `\cref{thm:nonempty_jacobianWitness}` (intro, route-(b), C.2.d, build-order) — exists in
  `Jacobian.tex` (cross-chapter; intentional, mirrors the gated-gap family framing).
- `\cref{lem:Scheme_Over_ext_of_diff_zero}` from the envelope summary — exists in this chapter.
- `\cref{subsec:RigidityKbar_piece_i_decomposition}`, `\cref{sec:RigidityKbar_shared_pile}`,
  `\cref{lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero}`,
  `\cref{lem:constants_integral_over_base_field}`,
  `\cref{lem:chart_algebra_df_zero_factors_through_constant_on_chart}`,
  `\cref{lem:chart_algebra_isPushout_of_affine_product}` — all exist in this chapter.

## References consulted
- `analogies/df-zero-production-iter155.md` — the authoritative source for the re-scope:
  global-sections `df=0 ⟺ H^0(C,Ω_C)=0` decomposition, gap (i)/(ii) LOC budgets,
  `GroupLieAlgebra` non-portability, `Submodule.linearMap_eq_zero_iff_of_span_eq_top`
  cheap glue, and the "no chart-local route / Ω_C(V) free of rank 1" finding.

(No external-source citation blocks were added; the `df=0` decomposition is
Archon-original analysis, so no `% SOURCE`/`% SOURCE QUOTE` lines were written. No
existing `% SOURCE` blocks were modified.)

## Macros needed (if any)
- None. `\mathcal{H}om` (used once in the gap-(ii) bullet) is plain
  `\mathcal{...}` + literal "om" in math mode — renders as script-H followed by "om",
  no custom macro required.

## Notes for Plan Agent
- **`Jacobian.tex` C.2.d parallel `df=0` framing.** `Jacobian.tex` is a sibling chapter
  (out of my write-domain). Its `thm:nonempty_jacobianWitness` proof routes the genus-0
  sub-case through `thm:rigidity_over_kbar`; any C.2.d prose there that mirrors the
  now-corrected "chart-algebra avoids Serre duality" framing should be re-checked against
  the iter-155 global-sections finding. Not fixed here.
- **`sec:RigidityKbar_shared_pile` intro (≈L93)** describes M2.d-alt as "sidesteps
  Riemann–Roch by running the cotangent-vanishing argument directly". Per the analogist,
  the cotangent-vanishing argument itself needs `H^0(C,Ω)=0`, so this M2.d-alt
  description carries a residue of the same false framing. I left it (it concerns the
  M2.d-alt genus-0 *identification* consumer, not the rigidity keystone, and was outside
  the directive's enumerated targets), but it likely warrants a follow-up correction.
- **Protected `df_zero_factors` proof block still carries the framing.** Its Step-3
  "Cohomological content; no named Serre duality" paragraph (≈L1971) still says the
  "without Serre duality" disclaimer is "correct at the named-theorem level". Because the
  block is closed/axiom-clean and explicitly out-of-scope, I did not edit it; the new
  iter-155 disclosures elsewhere now contextualise it (converse vs production). If you
  want the in-proof framing aligned, that requires un-protecting the block.
- **Organizational mismatch.** The directive states "GrpObj.lean keeps its own chapter",
  but the GrpObj cotangent-globalisation blocks (`lem:GrpObj_mulRight_globalises`,
  `lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_free`, etc.) physically live in
  `RigidityKbar.tex` (≈L390–1820), not in a separate GrpObj chapter. The
  `% archon:covers` line I added claims only `RigidityKbar.lean` +
  `Cotangent/ChartAlgebra.lean`; if the file→chapter HARD-GATE expects GrpObj content in
  a different chapter, these blocks may need migrating (a structural-subagent job, not a
  blueprint-writer one).
- **Chapter size.** RigidityKbar.tex is ~2600 lines / >270 KB — too large to Read in one
  call. Consider splitting the GrpObj piece-(i) globalisation material (now largely
  off-path design-template record) into its own chapter.

## Strategy-modifying findings
None new. The chapter now *reflects* the strategy-level finding the directive carried
(the analogist's `df=0 ⟺ H^0(C,Ω_C)=0` global-sections decomposition and the
gap-(i)+(ii) / route-(b) gating); STRATEGY.md ownership of that finding is the plan
agent's, not introduced here.
