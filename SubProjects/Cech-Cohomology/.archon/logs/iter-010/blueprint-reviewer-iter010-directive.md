# Blueprint Reviewer Directive

## Slug
iter010

## Strategy snapshot

**Project end-state**: prove the protected, frozen-signature target
`AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`):
for `f : X ⟶ S` separated and quasi-compact, `F` quasi-coherent, `𝒰` a finite affine
open cover of `X`, an isomorphism `Nonempty ((CechComplex f 𝒰 F).homology i ≅
higherDirectImage f i F)` (under `[HasInjectiveResolutions X.Modules]`). Zero inline
`sorry` in the cone, zero project axioms. Route A (acyclic-resolution / Cartan–Leray),
NO spectral sequences.

**Phases & estimations** (remaining; full table verbatim):

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| P3 affine acyclicity (`CechAcyclic.affine`) — the long pole | ACTIVE (statement-gap fix first) | ~4–7 | ~250–550 | from-scratch: standard-cover Čech complex = complex of localisations; prime-local contracting homotopy `h(s)_{i₀…iₚ}=s_{i_fix i₀…iₚ}`; `isZero` via localise-at-prime. Mathlib LACKS all of these for `Scheme.Modules`. | Statement gap: blueprint proves STANDARD-cover; Lean sig takes general `X.OpenCover`. DECIDED: narrow non-protected signature to standard covers (downstream-safe via P5a basis lemma). Needs a "standard affine cover" Lean type. Every geometric node routes through this except `lem:higher_direct_image_presheaf`. |
| P5a vanishing inputs (mostly P3-dependent; one P3-independent leaf) | NEXT | ~3–6 | ~250–550 | augmented-Čech-is-a-resolution (`cechAugmented_exact`); presheaf description `R^if_*=sheafify(V↦H^i(f⁻¹V))` (`higher_direct_image_presheaf`, Stacks 01XJ); basis lemma `lem:cech_to_cohomology_on_basis`; affine Serre vanishing | All P5a decls ABSENT from Lean (scaffold first). `lem:higher_direct_image_presheaf` is the lone P3-independent leaf, BUT itself needs the rightDerived↔sheafified-presheaf-cohomology comparison for `Scheme.Modules` — Mathlib's version is `Sheaf J AddCommGrpCat`, wrong category, so also from-scratch. Statement↔proof parity on basis lemma still open. |
| P5b comparison assembly | LAST (needs P3, P4, P5a) | ~2–4 | ~150–300 | P3 + P4 + P5a + termwise `f_*`-acyclicity of `Cᵖ` | Final assembly of `cech_computes_higherDirectImage` from the resolution (P5a), termwise acyclicity (`cechTerm_pushforward_acyclic`), and the P4 acyclic-resolution comparison. Routes the general finite-affine `𝒰` through the basis lemma, NOT `CechAcyclic.affine` directly. Lean proof comment still describes the OLD spectral-sequence route — clean during a refactor. |

**Completed**: P1 push–pull functor laws, P2 CechNerve/CechComplex (both in `CechHigherDirectImage.lean`),
P4 abstract acyclic-resolution lemma (`AcyclicResolution.lean`, closed iter-009, axiom-clean).

## Routes

- **Route A — acyclic-resolution comparison (CHOSEN)**: augmented Čech complex is a resolution of `F`
  (P5a `cech_augmented_resolution`) whose terms are termwise `f_*`-acyclic (P5b `cechTerm_pushforward_acyclic`,
  via P3 affine vanishing); the P4 abstract lemma `rightDerivedIsoOfAcyclicResolution` then gives
  `Hⁱ(f_* C•) ≅ Rⁱf_* F`. Chapters exclusive to it: `Cohomology_CechHigherDirectImage.tex` (P3+P5),
  `Cohomology_AcyclicResolution.tex` (P4, done).
- **Route B — two spectral sequences (REJECTED, fallback only)**: not in the blueprint by design.

## References
- `references/stacks-coherent.tex`: Stacks "Cohomology of Schemes" — 02KE/02KG, standard-cover Čech vanishing
  (`lemma-cech-cohomology-quasi-coherent-trivial`), Serre vanishing, relative affine vanishing. Backs the
  P3/P5 blocks in `Cohomology_CechHigherDirectImage.tex`.
- `references/stacks-cohomology.tex`: Stacks "Cohomology" — 01EO (`lemma-cech-vanish-basis`, basis comparison),
  01XJ (`lemma-describe-higher-direct-images`, presheaf description). Backs `lem:cech_to_cohomology_on_basis`
  and `lem:higher_direct_image_presheaf`.
- `references/homological-acyclic-derived.tex`: Stacks derived/homology — Leray acyclicity (015E). Backs P4 (done).

## Focus areas

**`Cohomology_CechHigherDirectImage.tex` is the priority.** It was rewritten by a blueprint-writer in iter-009
(de-spectral-sequencing three blocks to Route A: `lem:cech_to_cohomology_on_basis`,
`lem:open_immersion_pushforward_comp` part (2), `lem:cech_term_pushforward_acyclic`) and has NOT been
re-reviewed since. It is the consolidated chapter for the one remaining Lean file
`CechHigherDirectImage.lean`, and gates ALL remaining prover work (P3, P5a, P5b). I need a fresh HARD GATE
verdict on every block that feeds a near-term prover lane, in particular:
- `lem:cech_acyclic_affine` (P3, the long pole — `CechAcyclic.affine`, currently a Lean sorry): is the
  proof sketch detailed enough to guide a from-scratch build of the module-localisation Čech complex +
  prime-local contracting homotopy? Or does it need effort-breaking into sub-lemmas first?
- `lem:cech_to_cohomology_on_basis`: STATEMENT↔PROOF PARITY — the statement is still the general Stacks-01EO
  basis criterion (ringed space, arbitrary basis + Cov), but the rewritten proof argues only the
  affine/standard-cover instance via the P4 acyclic-resolution route. Flag whether the statement should be
  narrowed to the affine case to match the proof and the `\lean{}` target.
- `lem:higher_direct_image_presheaf` (the lone P3-INDEPENDENT frontier leaf): is its sketch adequate for a
  from-scratch build of the `Rⁱf_*` = sheafification-of-cohomology-presheaf comparison for `Scheme.Modules`?
- `lem:cech_augmented_resolution`, `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`:
  are the Route-A proofs complete + correct, with accurate `\uses{}`?

Also assess the file-split question for parallelism: P3 acyclicity, presheaf-description, Čech-term
acyclicity, and the protected assembly all live in one Lean file / one chapter. If the chapter naturally
decomposes into clusters that should become separate `.lean` files (each parallel-provable), note it.

## Known issues (do not re-report)
- `Cohomology_AcyclicResolution.tex` is `complete + correct` (iter-009 HARD GATE cleared, P4 closed,
  lean-vs-blueprint-checker 0 must-fix). Only a known minor: the augmentation-dropped encoding
  (`e : A ≅ K.cycles 0`) isn't noted in the statement block — already on my list, do not re-flag as must-fix.
- `Cohomology_HigherDirectImage.tex` is a thin live pointer (defines `higherDirectImage`), known complete.
- The `.lean` files carry stale narrative comments (old spectral-sequence route in the
  `cech_computes_higherDirectImage` sorry body; "remaining"/"not yet closed" blocks) — these are `.lean`
  issues outside your scope; do not report them as blueprint findings.
