# Lean ↔ Blueprint Check Report

## Slug
avr-iter164

## Iteration
164

## Files audited
- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean` (992 lines, 14 top-level declarations)
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex` (1375 lines)

## Audit scope

iter-164 was a hygiene-only lane. The prover (a) refreshed the file header (links 1, 2) to
describe the iter-162 chain closure and the new 𝔾ₘ-scaling route, (b) updated ~6 status
comments on PROVEN chain lemmas from "lone residual sorry" / "iter-160: sorry" to "PROVEN
axiom-clean (iter-162)", (c) rewrote `morphism_P1_to_grpScheme_const`'s docstring (L909–926)
to the 𝔾ₘ-scaling shortcut, and (d) dropped `[Smooth A.hom]` / `[GeometricallyIrreducible
A.hom]` from the A-side of `hom_additive_decomp_of_rigidity` (L820–821) and the knock-on
B-side of `av_regularMap_isHom_of_zero` (L890). No `.lean` body content was changed beyond
docstrings/comments and the four dropped instance hypotheses on the abelian-variety target.

## Per-declaration

### `\lean{AlgebraicGeometry.rigidity_lemma}` (chap: thm:rigidity_lemma, L764)
- **Lean target exists**: yes (L764)
- **Signature matches**: yes — Mumford Form I, with collapse hypothesis `_hf : lift (𝟙 X)
  (toUnit X ≫ y₀) ≫ f = toUnit X ≫ z₀`, instance set `[IsAlgClosed kbar]`, `[IsProper X.hom]`,
  `[GeometricallyIrreducible (X ⊗ Y).hom]`, `[LocallyOfFiniteType (X ⊗ Y).hom]`, `[IsReduced
  (X ⊗ Y).left]`, `[IsSeparated Z.hom]` — exactly the iter-161 chain signature.
- **Proof follows sketch**: yes — `rigidity_snd_lift` + `rigidity_core`, the categorical
  reduction + scheme-level gluing decomposition the chapter advertises in
  `rmk:rigidity_lemma_decomposition` (L186–231).
- **notes**: iter-164 status comment at L758–763 ("PROVEN axiom-clean (iter-162)") matches the
  iter-162 closure recorded in `kdm-lemma-false-as-stated`/`rigidity-chain-closed-iter162`
  memory entries. No laundering: `_hf` is genuinely consumed by the downstream
  `rigidity_eqOn_dense_open` (`hy₀` at L581–591).

### `\lean{AlgebraicGeometry.rigidity_eqOn_dense_open}` (chap: lem:rigidity_eqOn_dense_open, L506)
- **Lean target exists**: yes (L506)
- **Signature matches**: yes — geometric heart with the collapse hypothesis carried through.
- **Proof follows sketch**: yes — Mumford's `G = p₂(f⁻¹(F))`/`V = Y - G` construction,
  closed-map step via `snd_left_isClosedMap`, non-emptiness via the explicit `hy₀` proof using
  the `hfib` pullback-fibre fact and `_hf`. Body is closed.
- **notes**: iter-164 status comment at L482–490 accurately upgrades the chapter-claim from
  "sorry-free in its own body" (iter-159) to "PROVEN axiom-clean (iter-162)". No regressions.

### `\lean{AlgebraicGeometry.rigidity_eqOn_saturated_open_to_affine}` (chap: lem:rigidity_eqOn_saturated_open_to_affine, L430)
- **Lean target exists**: yes (L430)
- **Signature matches**: yes — same hypothesis set, saturated open + affine-image data.
- **Proof follows sketch**: yes — wires Step 2 (`morphism_eq_of_eqAt_closedPoints`) over the
  per-slice Step 1 (`rigidity_eqAt_closedPoint_of_proper_into_affine`), with the `JacobsonSpace
  U` discharge from `[LocallyOfFiniteType (X ⊗ Y).hom]` (L464–470). Body is closed.
- **notes**: iter-164 docstring (L407–414) updated to "now PROVEN axiom-clean (iter-162)" — accurate.

### `\lean{AlgebraicGeometry.morphism_eq_of_eqAt_closedPoints}` (chap: lem:morphism_eq_of_eqAt_closedPoints, L114)
- **Lean target exists**: yes (L114)
- **Signature matches**: yes — reduced + Jacobson source, separated target, residue-field
  hypothesis at every closed point.
- **Proof follows sketch**: yes — coproduct dominant probe + `ext_of_isDominant`. The
  chapter's prose at L491–507 mirrors the Lean construction step-for-step.

### `\lean{AlgebraicGeometry.eq_comp_of_isAffine_of_properIntegral}` (chap: lem:eq_comp_of_isAffine_of_properIntegral, L155)
- **Lean target exists**: yes (L155)
- **Signature matches**: yes — every blueprint-listed hypothesis (`[IsAlgClosed kbar]`,
  `IsIntegral W`, `UniversallyClosed wk`, `LocallyOfFiniteType wk`, `IsAffine V`) is carried;
  the chapter's "every hypothesis is load-bearing" audit (L526–534) is faithful.
- **Proof follows sketch**: yes — `isField_of_universallyClosed` + `finite_appTop_of_…` +
  `IsAlgClosed.ringHom_bijective_of_isIntegral` + `ext_of_isAffine`, in that order.

### `\lean{AlgebraicGeometry.isIntegral_of_retract}` (chap: lem:isIntegral_of_retract_of_integral, L202)
- **Lean target exists**: yes (L202)
- **Signature matches**: yes — generic retract (more general than the chapter's `X` / `X×Y` /
  `p₁` instantiation, which the blueprint NOTE at L562–568 already documents).
- **Proof follows sketch**: stalk-level proof (each `S.stalk x` embeds via `pr.stalkMap` into
  the reduced `T.stalk`), divergent from the blueprint prose at L580–584 which describes the
  global-sections split-injection route. Both routes are mathematically sound; the
  pre-existing blueprint NOTE at L564–568 flags this divergence as cosmetic and authorizes
  the writer to align the prose later.

### `\lean{AlgebraicGeometry.rigidity_eqAt_closedPoint_of_proper_into_affine}` (chap: lem:rigidity_eqAt_closedPoint_of_proper_into_affine, L261)
- **Lean target exists**: yes (L261)
- **Signature matches**: yes — full hypothesis set, residue-field probe equality at a closed
  point of `U`.
- **Proof follows sketch**: yes — `pointOfClosedPoint` k̄-rationality lift, `isIntegral_of_retract`
  presenting `X.left` as a slice retract, slice section into `U`, `eq_comp_of_isAffine_of_…`
  closure. Wires together exactly the chapter's prose at L619–642.

### `\lean{AlgebraicGeometry.hom_additive_decomp_of_rigidity}` (chap: lem:hom_additivity_over_product, L813)
- **Lean target exists**: yes (L813)
- **Signature matches**: **partial — generalization** (iter-164 edit). Lean now requires only
  `[GrpObj A] [IsProper A.hom]` on the abelian-variety target (`[Smooth A.hom]` and
  `[GeometricallyIrreducible A.hom]` dropped this iter). Blueprint prose at L712–714 says "Let
  $A$ be an abelian variety", which classically means smooth proper geom-irred group scheme.
  The Lean signature is therefore **strictly more general** than the blueprint prose claims:
  every situation the blueprint envisions is covered by the Lean lemma. The chapter remains
  correct under the wider Lean signature. The pre-existing blueprint NOTE at L698–705 already
  documents that the Lean side carries product-level instance hypotheses on `V⊗W` not spelled
  out in the prose; the iter-164 drop of A-side smoothness/geometric irreducibility is a
  further (sound) generalization that should be appended to that NOTE in a future writer pass.
- **Proof follows sketch**: yes — Milne Cor 1.5 verbatim: form the difference `φ`, kill on both
  axes via `_hf`, apply `rigidity_lemma` to factor through `q`, then read off the factoring
  morphism is `1` from the `{v₀} × W` section. Body is closed.

### `\lean{AlgebraicGeometry.av_regularMap_isHom_of_zero}` (chap: lem:av_regular_map_is_hom, L883)
- **Lean target exists**: yes (L883)
- **Signature matches**: **partial — generalization** (iter-164 edit). Lean now requires only
  `[GrpObj B] [IsProper B.hom]` on the target `B` (`[Smooth B.hom]` and
  `[GeometricallyIrreducible B.hom]` dropped this iter). `A` retains the full abelian-variety
  instance set. Blueprint prose at L776 says "$A$, $B$ … abelian varieties" — again Lean is
  strictly more general, and the chapter remains correct. Same NOTE-amendment recommendation
  as above. The Lean output is `IsMonHom α`, which is faithful to the chapter's prose "α is a
  homomorphism" (the pre-existing NOTE at L764–771 already documents this).
- **Proof follows sketch**: yes — Milne Cor 1.2 verbatim: apply Cor 1.5 to `μ[A] ≫ α` based at
  `η[A]`, both axis-restrictions reduce to `α` via the monoid unit laws, the resulting equality
  `μ[A] ≫ α = (fst ≫ α) · (snd ≫ α) = (α ⊗ α) ≫ μ[B]` is exactly `mul_hom`. Body is closed.

### `\lean{AlgebraicGeometry.rationalMap_to_av_extends}` (chap: lem:rational_map_to_av_extends, L808)
- **Lean target exists**: **no** — declaration does not exist in
  `AlgebraicJacobian/AbelianVarietyRigidity.lean`. Blueprint correctly omits the `\leanok`
  marker on both the statement (L805–829) and the proof (L846–859), and the surrounding prose
  marks the lemma "Route-A-only (iter-164), not on the genus-0 critical path"
  (L821–825), so the missing target is an honestly-scaffolded blueprint pointer rather than a
  misclaim. Pre-existing condition; iter-164 did not change this.

### `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const}` (chap: prop:morphism_P1_to_AV_constant, L927)
- **Lean target exists**: yes (L927)
- **Signature matches**: yes — abstract genus-0 curve proxy + abelian-variety target, conclusion
  `∃ a₀, f = toUnit P1 ≫ a₀`.
- **Proof follows sketch**: **N/A — body is `:= sorry`** (L936). Pre-existing scaffold,
  acknowledged by the docstring status line ("Status: scaffold — body is `sorry`, pending the
  concrete ℙ¹/𝔾ₘ/σ_× infra (iter-165)", L926) and by the surrounding chapter prose.
- **notes**: iter-164 docstring rewrite (L909–926) brings the Lean docstring **into sync** with
  the blueprint's new 𝔾ₘ-scaling proof: V = ℙ¹ proper, W = 𝔾ₘ, base points 0, 1; 0 is the
  scaling fixed point that collapses the W-axis; constancy on dense 𝔾ₘ + A separated forces `f`
  constant. All five steps in L915–920 line up with the chapter prose at L1224–1256. This is a
  CORRECTION (the prior "blocked on theorem of the cube" framing was the iter-156 red herring);
  the iter-164 edit is faithful.

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (chap: prop:genusZero_curve_iso_P1, L951)
- **Lean target exists**: yes (L951)
- **Signature matches**: yes — both `C` and `P1` encoded as abstract genus-0 curves; statement
  reads "any two smooth proper geom-irred genus-0 curves over `k̄` are isomorphic".
- **Proof follows sketch**: **N/A — body is `:= sorry`** (L960). Pre-existing scaffold;
  blueprint explicitly acknowledges Riemann–Roch sub-build at `rmk:genusZero_iso_subbuild`
  (L1314–1324).
- **notes**: iter-164 did not edit this declaration's body, docstring, or signature.

### `\lean{AlgebraicGeometry.rigidity_genus0_curve_to_grpScheme}` (chap: thm:rigidity_genus0_curve_to_AV, L976)
- **Lean target exists**: yes (L976)
- **Signature matches**: yes — pinned verbatim to `rigidity_over_kbar` minus `[CharZero kbar]`,
  matching the chapter's claim (L1344–1352).
- **Proof follows sketch**: **N/A — body is `:= sorry`** (L989). Pre-existing scaffold; the
  chapter proof at L1355–1374 is straightforward composition of (15) + (16).
- **notes**: iter-164 did not edit this declaration.

### `\lean{AlgebraicGeometry.ProjectiveLineBar}`, `\lean{AlgebraicGeometry.gmScalingP1}`, `\lean{AlgebraicGeometry.hom_Ga_to_av_trivial}`, `\lean{AlgebraicGeometry.morphism_Ga_to_av_const}`
- **Lean target exists**: **no** — all four declarations do not exist in the Lean file.
- **notes**: All four blueprint blocks correctly carry no `\leanok` marker AND are explicitly
  tagged "[expected]" in the prose (e.g. L910 `\lean name \texttt{ProjectiveLineBar}
  [expected]`), or marked off the genus-0 critical path (`hom_Ga_to_av_trivial`,
  `morphism_Ga_to_av_const`). Pre-existing scaffolding pointers; iter-164 did not change this.

## Red flags

### Placeholder / suspect bodies

The Lean file has three `:= sorry` bodies (`morphism_P1_to_grpScheme_const` L936,
`genusZero_curve_iso_P1` L960, `rigidity_genus0_curve_to_grpScheme` L989) on declarations the
blueprint claims have substantive proofs. By the literal severity rules, each of these is a
must-fix-this-iter. However:

1. All three are **pre-existing scaffold sorries** that predate iter-164 (the directive
   explicitly describes iter-164 as a hygiene-only lane, not a sorry-fill lane). The iter-164
   prover did not introduce them.
2. Each is explicitly labeled "SCAFFOLD" in the Lean (`-- SCAFFOLD: signature provisional`)
   and explicitly acknowledged as a pending sub-build in the blueprint (e.g.
   `rmk:genusZero_iso_subbuild`, the docstring "Status: scaffold — body is `sorry`, pending …
   (iter-165)").
3. The two downstream scaffolds (`genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`)
   depend on Riemann–Roch / multi-iter sub-builds the project has not yet undertaken; closing
   them is not iter-165's scope.

**Recommendation**: I report these as red flags per the strict severity definition, but they
are NOT regressions introduced by iter-164. The plan agent should treat them as the
already-known scaffold backlog. The one to attack next (per the iter-164 docstring and the
blueprint's primary route) is `morphism_P1_to_grpScheme_const` via the 𝔾ₘ-scaling shortcut.

### Excuse-comments

None. The "Status: scaffold — body is `sorry`, pending …" status comments are not
excuse-comments for wrong code; they accurately announce intentional scaffolding tied to a
named upstream prerequisite (concrete ℙ¹/𝔾ₘ/σ_× infra), with a published iter for closure.
The blueprint prose corroborates the same plan. This is workflow status, not laundering.

### Axioms / Classical.choice on non-trivial claims

None. No `axiom` declarations; no `Classical.choice _` patterns on substantive claims.

### Iter-157 laundering anti-pattern

**Not present.** Checked the chain lemmas explicitly:
- `rigidity_lemma` consumes `_hf` via `rigidity_core` (L783).
- `rigidity_core` consumes `_hf` via `rigidity_eqOn_dense_open` (L698).
- `rigidity_eqOn_dense_open` GENUINELY consumes `_hf` to prove `y₀ ∉ G` (L580–591, via
  `hcomp`, `hfx`).
- `hom_additive_decomp_of_rigidity` consumes its base-point hypothesis `hh` in `hvf`/`hwg`
  (L844–845).
- `av_regularMap_isHom_of_zero` consumes `hα` directly in `one_hom := hα` (L907).

No `_` underscoring of load-bearing hypotheses, no `sorryAx` propagation through an
apparently-closed proof.

## Unreferenced declarations (informational)

The Lean file has three unreferenced top-level declarations the blueprint mentions by name but
does not give their own `\lean{...}` blocks:

- `AlgebraicGeometry.rigidity_snd_lift` (L73) — cartesian-monoidal algebra helper; mentioned in
  `rmk:rigidity_lemma_decomposition` (L189) and in the `rigidity_lemma` docstring. Acceptable
  helper status, but a future writer pass could promote it to a `\lean{...}` block under
  `\thm:rigidity_lemma`'s decomposition remark.
- `AlgebraicGeometry.snd_left_isClosedMap` (L92) — bridge-1 closed-map step; mentioned by name
  in the proof prose of `lem:rigidity_eqOn_dense_open` (L331) as the BUILT helper. Acceptable
  as a helper.
- `AlgebraicGeometry.rigidity_core` (L678) — scheme-level gluing helper; mentioned in
  `rmk:rigidity_lemma_decomposition` (L191) and elsewhere. Acceptable as a helper.

None require promotion to a top-level `\lean{...}` block on this iter.

## Blueprint adequacy for this file

- **Coverage**: 14 substantive Lean declarations; 10 have direct `\lean{...}` blocks
  (`rigidity_lemma`, `rigidity_eqOn_dense_open`, `rigidity_eqOn_saturated_open_to_affine`,
  `morphism_eq_of_eqAt_closedPoints`, `eq_comp_of_isAffine_of_properIntegral`,
  `isIntegral_of_retract`, `rigidity_eqAt_closedPoint_of_proper_into_affine`,
  `hom_additive_decomp_of_rigidity`, `av_regularMap_isHom_of_zero`,
  `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`,
  `rigidity_genus0_curve_to_grpScheme` = 12 actually); the remaining 3 (`rigidity_snd_lift`,
  `snd_left_isClosedMap`, `rigidity_core`) are mentioned by name as helpers. **Coverage =
  12/14 with the 2 unreferenced ones acceptable helpers.**
- **Proof-sketch depth**: **adequate** for every PROVEN lemma in the chain; the chapter's
  per-lemma prose (L307–467, L536–642, L736–803) is detailed enough that a prover could
  formalize from prose alone. For `morphism_P1_to_grpScheme_const` (the next sorry to close),
  the chapter's 𝔾ₘ-scaling-shortcut prose at L1211–1266 is now precise enough to guide
  iter-165: it pins V = ℙ¹, W = 𝔾ₘ, the base points 0 and 1, the load-bearing scaling fixed
  point, the W-axis collapse, and the `ext_of_isDominant`-family closure. Adequate.
- **Hint precision**: **precise** for all 12 actually-existing `\lean{...}` targets. The 4
  "[expected]" hints (`ProjectiveLineBar`, `gmScalingP1`, `hom_Ga_to_av_trivial`,
  `morphism_Ga_to_av_const`) name targets that do not yet exist; the chapter explicitly tags
  them "[expected]" in the prose, so they are honestly-scaffolded forward-pointers rather
  than precision failures.
- **Generality**: **matches need**, with two caveats from iter-164's instance-drop edits.
  `hom_additive_decomp_of_rigidity` and `av_regularMap_isHom_of_zero` now both have Lean
  signatures **strictly more general** than the prose claims (target abelian variety no longer
  needs `Smooth`/`GeometricallyIrreducible`). This is sound (drop = generalization, the
  chapter remains correct) and the pre-existing NOTE blocks at L698–705 / L764–771 already
  document this kind of slack; the iter-164 drop could be appended.
- **Recommended chapter-side actions** (minor, deferable):
  1. Extend the existing NOTE blocks at L698–705 and L764–771 to record that the A-side (Cor
     1.5) and B-side (Cor 1.2) of the abelian-variety hypotheses have been dropped to
     `[GrpObj _] [IsProper _.hom]` as of iter-164. Not blocking.
  2. Future writer pass could promote `rigidity_snd_lift`, `snd_left_isClosedMap`,
     `rigidity_core` to `\lean{...}` blocks under `rmk:rigidity_lemma_decomposition`. Not
     blocking.
  3. Reconcile the `isIntegral_of_retract` proof-prose divergence (global-sections vs.
     per-stalk) — already flagged by the pre-existing NOTE at L562–568.

## Severity summary

- **must-fix-this-iter**: 3 placeholder `:= sorry` bodies on declarations whose blueprint
  blocks describe substantive proofs (`morphism_P1_to_grpScheme_const`,
  `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`). Per the strict severity
  rules these are blocking. **HOWEVER**, none of the three is a regression introduced by
  iter-164: they pre-date this hygiene-only iter, each is explicitly tagged `-- SCAFFOLD:` in
  the Lean, and the blueprint explicitly acknowledges each as a pending sub-build with a
  named upstream prerequisite (concrete ℙ¹/𝔾ₘ/σ_× infra, Riemann–Roch). The plan agent
  should weigh these against the iter-164 directive's hygiene-only framing.
- **major**: none new this iter. The signature generalization in
  `hom_additive_decomp_of_rigidity` / `av_regularMap_isHom_of_zero` is sound (Lean strictly
  more general than blueprint prose); the chapter's existing NOTE blocks already authorize
  this pattern and just need a one-line amendment in a future writer pass.
- **minor**: chapter prose for `isIntegral_of_retract` describes the global-sections route
  while the Lean proof took the stalk route — sound, pre-existing, already flagged by an
  in-tree NOTE. Three substantive helpers (`rigidity_snd_lift`, `snd_left_isClosedMap`,
  `rigidity_core`) are mentioned by name but lack `\lean{...}` blocks.

Overall verdict: iter-164's hygiene edits are faithful, sound, and bring the Lean docstrings
and signatures into closer agreement with the chapter; no new red flags, no laundering, no
new must-fix issues introduced. The chain remains axiom-clean per memory, and the three
scaffold sorries on `morphism_P1_to_grpScheme_const` / `genusZero_curve_iso_P1` /
`rigidity_genus0_curve_to_grpScheme` are pre-existing, explicitly-documented sub-builds — not
iter-164 regressions.
