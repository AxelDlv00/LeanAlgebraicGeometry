# AlgebraicJacobian/Cohomology/CechBridge.lean

## Summary

- **Declarations added (2, both axiom-clean `{propext, Classical.choice, Quot.sound}`):**
  - `AlgebraicGeometry.sectionCech_objD_exact_of_isZero_homology` (line 456) — converse of
    CechAcyclic's `sectionCech_isZero_homology_of_objD_exact`: `IsZero (homology (q+1))` ⟹
    `Function.Exact (objD q) (objD (q+1))` on underlying groups.
  - `AlgebraicGeometry.sectionCech_one_coboundary_of_isZero_homology` (line 495) — the
    `\uses{def:cech_complex}` heart of `ses_cech_h1`: **Ȟ¹(𝒰,F)=0 ⟹ every Čech 1-cocycle is a
    coboundary**, in section coordinates (`sectionCechProductEquiv` / `sectionCech_objD_apply`).
- **New import added:** `import AlgebraicJacobian.Cohomology.CechAcyclic` (no cycle — CechAcyclic does
  not import CechBridge). This unlocks reuse of the section-Čech-complex machinery
  (`sectionCechProductEquiv`, `sectionCech_objD_apply`, `sectionCechFaceRestr`,
  `sectionCech_isZero_homology_of_objD_exact`), avoiding ~100 lines of re-derivation.
- **Declarations blocked (1):** `ses_cech_h1` — NOT added (would require a `sorry`, forbidden).
  The remaining gap is pure sheaf theory (local surjectivity extraction + Grothendieck-topology
  gluing), not Čech algebra. Precise decomposition below.
- **sorry count across file: 0 → 0.** Build GREEN (`lake build` succeeds, 8326 jobs).

## sectionCech_objD_exact_of_isZero_homology (line 456) — RESOLVED, axiom-clean
- **Approach:** Mirror of `sectionCech_isZero_homology_of_objD_exact` (CechAcyclic) run in the
  extraction direction. The bridge `exactAt_iff_isZero_homology` / `exactAt_iff'` /
  `ShortComplex.ab_exact_iff_function_exact` is a chain of iff-rewrites, so applying them to the
  hypothesis `h : IsZero homology` yields `Function.Exact` of the ShortComplex maps, which are
  defeq to the `d`'s; `CochainComplex.of_d … AlternatingCofaceMapComplex.d_squared` (`hf`,`hg`)
  identifies `d` with `objD`.
- **Result:** RESOLVED.

## sectionCech_one_coboundary_of_isZero_homology (line 495) — RESOLVED, axiom-clean
- **Approach:** (1) `sectionCech_objD_exact_of_isZero_homology … 0` gives
  `Function.Exact (objD 0) (objD 1)`. (2) Lift the coordinate cocycle `c` to the abstract cochain
  `c' := (sectionCechProductEquiv U F 1).symm c`. (3) Show `objD 1 c' = 0` by `productEquiv`
  injectivity + `sectionCech_objD_apply` (q=1) coordinate-wise = `hcoc`; zero coordinate via
  `sectionCechProductEquiv_apply` + `map_zero`. (4) `Function.Exact.mp` extracts `b` with
  `objD 0 b = c'`. (5) `t := sectionCechProductEquiv U F 0 b`; the conclusion is
  `sectionCech_objD_apply` (q=0) read back through `hpe1`.
- **Conclusion form:** the coboundary is given as the raw alternating sum
  `c σ = ∑ i:Fin 2, (-1)^i • sectionCechFaceRestr U F σ i (t (σ ∘ δ i))`. The consumer expands to the
  blueprint two-term form `c σ = t_{σ1}|_σ − t_{σ0}|_σ` in one line:
  `rw [Fin.sum_univ_two]; simp [pow_zero, pow_one]; abel` (verified in scratch).
- **Result:** RESOLVED.

## ses_cech_h1 — NOT ADDED (blocked on sheaf theory; would need sorry)
- **What is done:** the Čech-algebra core it `\uses{def:cech_complex}` is now in-file
  (`sectionCech_one_coboundary_of_isZero_homology`).
- **What remains (pure sheaf theory, each a substantial sub-development):**
  1. **Signature design.** `F G H : X.Modules` (= `SheafOfModules X.ringCatSheaf`, a sheaf over the
     Grothendieck topology `Opens.grothendieckTopology ↥X`). SES = `ShortComplex` with `ShortExact`,
     or an explicit mono `F→G` + epi `G→H` + exactness. `U : Opens ↥X`. The "cofinal system with
     Ȟ¹=0" is best phrased operatively: *for every `s ∈ H(U)` there is a cover `𝒰 : ι → Opens ↥X`
     with `⨆ 𝒰 = U`, `IsZero ((sectionCechComplex 𝒰 F.toPresheaf).homology 1)`, and each `s|_{𝒰 i}`
     lifts to `G(𝒰 i)`.* Conclusion: `Function.Surjective (sections map G(U) → H(U))`.
  2. **Local surjectivity ⟹ lifting (property (b)).** Mathlib: epi of sheaves ⇒ locally surjective.
     - `CategoryTheory.Sheaf.isLocallySurjective_iff_epi` (`Mathlib/CategoryTheory/Sites/LocallySurjective.lean`)
     - `PresheafOfModules.IsLocallySurjective` (`Mathlib/Algebra/Category/ModuleCat/Sheaf.lean`)
     - `TopCat.Presheaf.IsLocallySurjective` (`Mathlib/Topology/Sheaves/LocallySurjective.lean`)
     Locate the bridge `Epi (G→H in X.Modules) → IsLocallySurjective` and unfold to "each germ/each
     small enough open has a section lift". This gives the cover with property (b).
  3. **Differences land in F (the cocycle).** `c σ = s_{σ1}|_σ − s_{σ0}|_σ` maps to 0 in `H` (both
     lift the single `s`), so by exactness of `F→G→H` on sections it lifts to `F(⨅ 𝒰(σ k))`. The
     cocycle identity `objD 1 c = 0` is then automatic — `c` is `objD 0` of the `s`-family, so
     `d²=0` (`AlternatingCofaceMapComplex.d_squared`) gives it. **Then feed
     `sectionCech_one_coboundary_of_isZero_homology` to get `t_i ∈ F(𝒰 i)`.**
  4. **Glue `s_i − t_i`.** They agree on overlaps (by construction). Use the sheaf condition
     `SheafOfModules.isSheaf : Presheaf.IsSheaf J self.val.presheaf` + the Grothendieck-topology
     amalgamation (`Presheaf.IsSheaf.amalgamate` / `Presheaf.IsSheaf`-gluing on the cover sieve of
     `𝒰` covering `U`). The glued section of `G(U)` maps to `s`.
- **Dead-end warning:** do NOT try to re-derive the section-complex homology bridge inside CechBridge
  — it already exists in CechAcyclic and is now imported. Use it.
- **No informal-agent help:** no external LLM API key in env (per PROGRESS.md); LSP search used.

## Needs blueprint entry

Both new non-private theorems are `lean_aux` nodes (no blueprint block yet). They belong under
`chapters/Cohomology_CechHigherDirectImage.tex`, naturally as helper lemmas of `lem:ses_cech_h1`
(and siblings of `lem:section_cech_homology_exact`):

- **`AlgebraicGeometry.sectionCech_objD_exact_of_isZero_homology`** — file `CechBridge.lean`.
  Relies on: `HomologicalComplex.exactAt_iff_isZero_homology`, `HomologicalComplex.exactAt_iff'`,
  `ShortComplex.ab_exact_iff_function_exact`, `CochainComplex.of_d`,
  `AlternatingCofaceMapComplex.d_squared`. Converse of the existing `lem:section_cech_homology_exact`
  Ab-side bridge — could be bundled into `lem:section_cech_homology_exact`'s `\lean{...}` list, or
  given its own block as the "extraction direction".
- **`AlgebraicGeometry.sectionCech_one_coboundary_of_isZero_homology`** — file `CechBridge.lean`.
  Relies on: the above, `sectionCechProductEquiv`(+`_apply`), `sectionCech_objD_apply`,
  `sectionCechFaceRestr` (all CechAcyclic), `Function.Exact`, `map_zero`. This is the
  `\uses{def:cech_complex}` content of `lem:ses_cech_h1`; suggest a dedicated block
  `lem:cech_one_coboundary` (or fold into `lem:ses_cech_h1`'s `\lean{...}` list) so the DAG keeps the
  1-to-1 Lean↔blueprint correspondence.

## Why I stopped

**Partial progress.** Added 2 axiom-clean declarations:
- `sectionCech_objD_exact_of_isZero_homology` (line 456)
- `sectionCech_one_coboundary_of_isZero_homology` (line 495)

These are the complete Čech-algebra core that `ses_cech_h1` `\uses{def:cech_complex}` — the homology
vanishing ⟹ 1-coboundary extraction, in usable section coordinates. The named target `ses_cech_h1`
is **not added** because its residual is genuinely sheaf-theoretic (local-surjectivity extraction of
section lifts + Grothendieck-topology gluing of the corrected sections), each a substantial
sub-development that cannot be completed axiom-clean in one iteration; per the no-sorry invariant I
left it absent rather than pin a `sorry`. The precise decomposition + located Mathlib API is above so
the next prover can build pieces 2 and 4 and assemble. **Blocker, precisely:** the
`Epi (G→H : X.Modules) → ∃ cover, sections lift` extraction and the
`Presheaf.IsSheaf (Opens.grothendieckTopology ↥X) G.val.presheaf` amalgamation over a cover sieve —
neither is a one-liner; both are absent in directly-usable form for `SheafOfModules` over a scheme.
