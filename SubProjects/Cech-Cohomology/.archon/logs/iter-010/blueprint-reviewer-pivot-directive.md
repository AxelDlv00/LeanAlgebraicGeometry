# Blueprint Reviewer Directive

## Slug
pivot

## Strategy snapshot

End-state goal: prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`) — for `f : X ⟶ S` separated quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover, `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under `[HasInjectiveResolutions X.Modules]`). Route A (acyclic-resolution / Cartan–Leray comparison), NO spectral sequences.

P4 (abstract acyclic-resolution lemma, `Cohomology_AcyclicResolution.tex`) just CLOSED — `rightDerivedIsoOfAcyclicResolution` and `rightDerivedOneIsoCokerOfAcyclic` are proven, axiom-clean. It is now an off-the-shelf engine the Čech side plugs into.

The pivot this iter is to the Čech side. The `## Phases & estimations` table:

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| P3 affine acyclicity (`CechAcyclic.affine`) — the long pole | ACTIVE (statement-gap fix first) | ~4–7 | ~250–550 | from-scratch: standard-cover Čech complex = complex of localisations; prime-local contracting homotopy `h(s)_{i₀…iₚ}=s_{i_fix i₀…iₚ}`; `isZero` via localise-at-prime. Mathlib LACKS all of these for `Scheme.Modules`. | Statement gap: blueprint proves STANDARD-cover; Lean sig takes general `X.OpenCover`. DECIDED: narrow non-protected signature to standard covers (downstream-safe via P5a basis lemma). Every geometric node routes through this except `lem:higher_direct_image_presheaf`. |
| P5a vanishing inputs (mostly P3-dependent; one P3-independent leaf) | NEXT | ~3–6 | ~250–550 | augmented-Čech-is-a-resolution (`cechAugmented_exact`); presheaf description `R^if_*=sheafify(V↦H^i(f⁻¹V))` (`higher_direct_image_presheaf`, Stacks 01XJ); basis lemma `lem:cech_to_cohomology_on_basis`; affine Serre vanishing | All P5a decls ABSENT from Lean (scaffold first). `lem:higher_direct_image_presheaf` is the lone P3-independent leaf but itself needs the rightDerived↔sheafified-presheaf-cohomology comparison for `Scheme.Modules` (Mathlib's is `Sheaf J AddCommGrpCat`, wrong category). Statement↔proof parity on basis lemma still open. |
| P5b comparison assembly | LAST (needs P3, P4, P5a) | ~2–4 | ~150–300 | P3 + P4 + P5a + termwise `f_*`-acyclicity of `Cᵖ` | Final assembly of `cech_computes_higherDirectImage` (protected, frozen sig+path) from resolution (P5a) + termwise acyclicity (`cechTerm_pushforward_acyclic`) + the P4 engine. |

## Routes

Single route — Route A (acyclic-resolution / Cartan–Leray comparison). Route B (two spectral sequences) is REJECTED (both SS absent from Mathlib); it must NOT reappear in any proof sketch. A central gate question this iter: confirm the `Cohomology_CechHigherDirectImage.tex` chapter is now fully Route-A-clean (no residual spectral-sequence argument) after the iter-009 de-spectral-sequencing rewrite.

## References
- `references/stacks-coherent.md` → `stacks-coherent.tex`: Stacks "Cohomology of Schemes" — tags 02KE (Čech computes cohomology), 02KG (Serre affine vanishing), `lemma-cech-cohomology-quasi-coherent-trivial` (standard-cover Čech vanishing), `lemma-relative-affine-vanishing`. Backs the whole Čech chapter.
- `references/stacks-cohomology.md` → `stacks-cohomology.tex`: Stacks "Cohomology" — 01XJ `lemma-describe-higher-direct-images` (R^i f_* = sheafify of V↦H^i(f⁻¹V)), 01EO `lemma-cech-vanish-basis` (basis comparison). Backs `lem:higher_direct_image_presheaf`, `lem:cech_to_cohomology_on_basis`.
- `references/homological-acyclic.md`: Stacks 015E Leray acyclicity — backs `Cohomology_AcyclicResolution.tex` (P4, done).

## Focus areas
`Cohomology_CechHigherDirectImage.tex` is GATE-CRITICAL this iter: it was rewritten by a blueprint-writer last iter (de-spectral-sequencing the three previously SS-contaminated blocks: `lem:cech_to_cohomology_on_basis`, `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`) and has NOT been re-reviewed since. The next prover lanes will all target Lean files covered by this consolidated chapter. For EACH of the to-be-scaffolded frontier targets — `lem:cech_augmented_resolution` (`cechAugmented_exact`), `lem:higher_direct_image_presheaf` (`higherDirectImage_isSheafify_presheafCohomology`), `lem:cech_to_cohomology_on_basis` (`cech_eq_cohomology_of_basis`), plus `lem:affine_serre_vanishing`, `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic` — render an explicit per-leaf verdict: is the sketch detailed + sound + directly-formalizable, and is the `\lean{}` target well-formulated? Pay special attention to: (a) any residual spectral-sequence reasoning; (b) the statement↔proof parity on `lem:cech_to_cohomology_on_basis` (statement is the general 01EO criterion, proof argues only the affine/standard-cover instance — is this a must-fix?); (c) whether `lem:higher_direct_image_presheaf`'s proof is adequate given Mathlib lacks the `Scheme.Modules` derived↔presheaf comparison.

## Known issues
- All P5 Lean decls (`cech_eq_cohomology_of_basis`, `cechAugmented_exact`, `higherDirectImage_isSheafify_presheafCohomology`, `affine_serre_vanishing`, `cechTerm_pushforward_acyclic`, `higherDirectImage_openImmersion_comp`) are ABSENT from Lean — these are scaffold (build-new-decl) targets, not fill-sorry. Do NOT report their absence as a Lean error; assess only the blueprint sketches' readiness for scaffolding + proving.
- `CechAcyclic.affine` (P3) has a known statement gap (general `X.OpenCover` in Lean vs standard-cover blueprint) — already tracked; a narrowing refactor is planned. Don't re-litigate the decision; do flag if the blueprint statement itself is internally inconsistent.
- Stale spectral-sequence comments inside the `.lean` files (P3 + protected assembly) are known and outside blueprint scope.
- P4 chapter (`Cohomology_AcyclicResolution.tex`) cleared the gate last iter and its targets are proven — a quick confirmation suffices; no deep re-audit needed.
