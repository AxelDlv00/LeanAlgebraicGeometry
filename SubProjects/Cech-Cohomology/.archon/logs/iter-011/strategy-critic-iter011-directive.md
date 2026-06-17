# Strategy Critic Directive

## Slug
iter011

## Project goal

Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (protected, frozen signature): for a
separated quasi-compact morphism `f : X ⟶ S`, a quasi-coherent `O_X`-module `F`, and a finite affine
open cover `𝒰` of `X`, there is an isomorphism (in weak-existence form
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)`, under
`[HasInjectiveResolutions X.Modules]`) between the cohomology of the relative Čech complex and the
right-derived direct image `higherDirectImage f i F = ((pushforward f).rightDerived i).obj F`.
End-state: zero inline `sorry` in this declaration's dependency cone, zero project axioms, kernel-only
axioms.

## Strategy under review

# Strategy

## Goal

Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`),
the protected, frozen-signature target: for `f : X ⟶ S` separated and quasi-compact, `F`
quasi-coherent, and `𝒰` a finite affine open cover of `X`, an isomorphism in the weak
existence form `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` (under
`[HasInjectiveResolutions X.Modules]`), where `higherDirectImage f i F =
((pushforward f).rightDerived i).obj F`. End-state: zero inline `sorry` in the cone, zero
project axioms, kernel-only axioms. Extraction from the Algebraic-Jacobian challenge; the
downstream Picard/Quot machinery is out of scope and was carved away.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| P3 standard-cover Čech vanishing (`CechAcyclic.affine`) | ACTIVE (statement-gap fix first) | ~3–5 | ~200–400 | cover-type `affineOpenCoverOfSpanRangeEqTop` + `exact_of_isLocalized_span` (both Mathlib-native); from-scratch L1 geometry↔algebra `Γ(D(f_σ))=M_{f_σ}` identification + L3 `Away(f_r)`-local contracting homotopy `h(s)_{i₀…iₚ}=s_{r i₀…iₚ}`. | Statement gap: narrow non-protected `CechAcyclic.affine` to a standard-cover bundle `(s,hs)`. Mathlib lacks the assembled `0→M→∏M_{f_i}→⋯` exactness (only the H⁰/H¹ equalizer); build L1+L3 around the two native idioms. Supplies only condition (3) of the bridge — NOT affine sheaf vanishing on its own. |
| P3b Čech↔derived bridge (minimal, torsor-free) → `affine_serre_vanishing` | NEXT (unblocks all geometry) | ~4–7 | ~300–600 | presheaf-Čech for `O_X`-modules: `PMod(O_X)` enough injectives; Čech complex exact as a functor on presheaves; `injective_cech_acyclic` (Stacks 01EN/`lemma-injective-trivial-cech`); `ses_cech_h1` (`lemma-ses-cech-h1`); `cech_vanish_basis` (01EO) dimension-shift. ALL absent from Mathlib for `O_X`-modules (`Sheaf J AddCommGrpCat` is the wrong category). | The irreducible brick the iter-009 plan wrongly denied needing: comparing the explicit Čech complex to `rightDerived` MUST cross "injectives are Čech-acyclic". Torsor sub-theory (`lemma-cech-h1`, `lemma-kill-cohomology-class`) is genuinely avoidable; this minimal route is not. Real from-scratch homological algebra over ringed-space `O_X`-modules. |
| P5a vanishing inputs (consume P3b) | AFTER P3b | ~3–5 | ~250–500 | augmented-Čech-is-a-resolution (`cechAugmented_exact`); presheaf description `R^if_*=sheafify(V↦H^i(f⁻¹V))` (`higher_direct_image_presheaf`, Stacks 01XJ — the one P3/P3b-independent leaf, itself from-scratch for `Scheme.Modules`); open-immersion/relative affine vanishing | All P5a decls ABSENT from Lean (scaffold first). `cechAugmented_exact` uses P3 (complex exactness, sound). `open_immersion_pushforward_comp` / `cech_term_pushforward_acyclic` consume `affine_serre_vanishing` from P3b. `higher_direct_image_presheaf` parallelisable (P3/P3b-independent). |
| P5b comparison assembly | LAST (needs P3, P3b, P4, P5a) | ~2–3 | ~150–300 | P4 engine + P5a resolution + termwise `f_*`-acyclicity | Final assembly of the protected `cech_computes_higherDirectImage` from the augmented-Čech resolution (P5a) + termwise acyclicity (via P3b affine vanishing) + the P4 acyclic-resolution comparison. Lean proof comment still describes the OLD spectral-sequence route — clean during the file-split refactor. |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| P1 push–pull functor laws | 002 · 2 | ~120 | `CechHigherDirectImage.lean` | `pushPullMap_comp` closing the push–pull functoriality cone | object-form align `simp [Functor.comp_obj]` before `reassoc_of%`; `rawPushPullMap`+`subst`+pentagon | `conjugateEquiv_comp` mate route INFEASIBLE (kernel `whnf` blow-up) |
| P2 `CechNerve`/`CechComplex` | 002 · 1 | ~60 | `CechHigherDirectImage.lean` | `pushPullFunctor` (G), `coverCechNerve(Aug)`, `CechNerve`, `CechComplex` axiom-clean | `Over.lift`+`.rightOp`+`CosimplicialObject.Augmented.whiskeringObj`; terminal-object augmentation | none |
| P4 acyclic-resolution lemma (Leray, Stacks 015E) | 009 · 6 (004–009) | ~965 | `AcyclicResolution.lean` | `rightDerivedIsoOfAcyclicResolution` (RⁿG ≅ Hⁿ(G K•)), `rightDerivedOneIsoCokerOfAcyclic`, horseshoe `ofShortExact`, dimension shift, cosyzygy layer — axiom-clean | decompose-then-build cadence; two-step `cokernel.mapIso` for non-syntactic homology naturality; `Nat.rec` staircase off `stairGen` | `ShortComplex.mapCyclesIso` WRONG for left-exact functor; `← G.map_comp` silently fails beside a mapped-complex term |

## Routes

### Route A — acyclic-resolution comparison (CHOSEN)
The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` (`Cᵖ = ∏ (j_s)_*(F|_{U_s})`) is
(i) a resolution of `F` and (ii) termwise `(pushforward f)`-acyclic. The P4 abstract lemma
"a `G`-acyclic resolution computes `G.rightDerived`" then gives `Hⁱ(f_* C•) ≅ Rⁱf_* F`
directly — ONE abstract lemma, NO spectral sequences. The standard Cartan–Leray acyclic-cover
existence proof. Its acyclicity input (ii) reduces to affine Serre vanishing
`H^q(affine, qcoh)=0`, which is NOT free: see the bridge below.

### Route B — two spectral sequences (REJECTED, fallback only)
Čech-to-derived + Leray spectral sequences for `Scheme.Modules`. Rejected: both absent from
Mathlib (multi-thousand-LOC), and Leray needs quasi-coherence of `R^q f_* F`. Strictly heavier
than Route A for the same `Nonempty (…≅…)` goal. NOTE: Route B rests on the SAME irreducible
brick `injective_cech_acyclic` as Route A — rejecting B does not escape it. Fallback only.

### The acyclicity bridge (load-bearing, CORRECTED)
Route A's term-/relative-acyclicity inputs and the general-cover intersection vanishing all
reduce to affine Serre vanishing `H^q(Spec A, qcoh)=0` (Stacks 02KG). This is NOT obtainable
from the P3 contracting homotopy alone: the homotopy proves the Čech *complex* is exact (a
resolution), but term `G`-acyclicity is itself affine vanishing on a smaller affine — a circular
regress with no inductive base. The honest route (Stacks, torsor-free) is the minimal
Čech↔derived bridge P3b: (1) injective `O_X`-modules are Čech-acyclic
(`injective_cech_acyclic`, via presheaf-level Čech + δ-functor universality); (2) `ses_cech_h1`;
(3) the dimension-shift `cech_vanish_basis` (01EO) consuming the standard-cover Čech vanishing of
P3 as its condition (3). This yields `affine_serre_vanishing` legitimately, breaking the cycle:
P3 produces standard-cover Čech vanishing; P3b lifts it to affine sheaf vanishing without ever
using affine vanishing as an input. The FULL Stacks-01EO bootstrap (torsor `lemma-cech-h1`,
`lemma-kill-cohomology-class`) is genuinely avoidable — only the injective-acyclicity brick is
irreducible (any comparison of an explicit complex to the injective-resolution-defined
`rightDerived` crosses it).

## Open strategic questions

- P3 cover-type: ALIGN to `AlgebraicGeometry.Scheme.affineOpenCoverOfSpanRangeEqTop s hs`
  (`Mathlib.AlgebraicGeometry.Cover.Open`) carrying the spanning-family bundle
  `(s : ι → A, hs : Ideal.span (Set.range s) = ⊤)` — the SAME datum `exact_of_isLocalized_span`
  consumes, so one bundle drives both geometry and algebra (zero bridge lemmas). Narrow only the
  non-protected `CechAcyclic.affine`; `cech_computes_higherDirectImage`/`CechComplex` stay general
  (the basis-comparison route isolates standard covers). See `analogies/p3-localisation.md`.
- P3 exactness: ALIGN to `exact_of_isLocalized_span` (`Mathlib.RingTheory.LocalProperties.Exactness`)
  — localise at the spanning elements `Away (f_r)` (not primes), node-by-node `Function.Exact`;
  then `D(f_r)` is the whole localised space and `i_fix=r` contracts globally. From-scratch: the
  L1 `Γ(D(f_σ))=M_{f_σ}` identification + the L3 localised module homotopy.
- P3b statement shape: prove the genuine basis criterion (`cech_vanish_basis`, 01EO) via the
  bridge, NOT the circular acyclic-resolution shortcut. Its `\uses` is
  `{injective_cech_acyclic, ses_cech_h1, cech_acyclic_affine}` and explicitly NOT
  `affine_serre_vanishing` (which depends on it). Decide whether to keep the general ringed-space
  statement or narrow to the affine/standard-cover instance — either is acceptable if non-circular.
- P3b scope guard: build the MINIMAL torsor-free bridge only. Do NOT formalize `lemma-cech-h1`
  (torsor H¹) or `lemma-kill-cohomology-class`; the dimension-shift route (`cech_vanish` /
  `cech_vanish_basis`) needs only `injective_cech_acyclic` + `ses_cech_h1`.
- File-split for parallelism (standing directive): split the one consolidated file into
  `CechAcyclic.lean` (P3), a presheaf-Čech-bridge file (P3b), `HigherDirectImagePresheaf.lean`
  (the P3-independent 01XJ leaf), and a trimmed `CechHigherDirectImage.lean` (P5 assembly), each a
  parallel prover lane under one `% archon:covers`. Keep `cech_computes_higherDirectImage`
  signature + path frozen. Execute as a refactor once the corrected blueprint clears the gate.

## Mathlib gaps & new material

Gaps to fill (project-side, Mathlib lacks):
- Standard-cover Čech complex exactness `0→M→∏M_{f_i}→⋯` (P3) — Mathlib has only the H⁰/H¹
  equalizer (`IsSheafEqualizerProducts`); assemble L1+L3 around `exact_of_isLocalized_span`.
- Presheaf-level Čech machinery for `O_X`-modules (P3b): `PMod(O_X)` enough injectives, Čech
  complex exact as a functor on presheaves, `injective_cech_acyclic`, `ses_cech_h1`,
  `cech_vanish_basis` — Mathlib's site cohomology is `Sheaf J AddCommGrpCat`, wrong category.
- `R^if_*` = sheafification of `V↦H^i(f⁻¹V,F)` for `Scheme.Modules` (`higher_direct_image_presheaf`,
  P5a) — from-scratch (Mathlib has it only for `Sheaf J AddCommGrpCat`).
- Relative/open-immersion affine vanishing `R^q(jₛ)_*=0`, `R^i(affine)_*=0` (P5).

New project material:
- push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `p ↦ p_* p^* F` — hand-rolled.
- `CechNerve` / `CechComplex` / `CechAcyclic.affine` (standard-cover bundle).
- `AcyclicResolution.lean`: abstract acyclic-resolution comparison (P4, done).
- P3b bridge (`injective_cech_acyclic`, `ses_cech_h1`, `cech_vanish_basis`) → `affine_serre_vanishing`.
- comparison assembly `cech_computes_higherDirectImage` via Route A.

## References index

This subproject was extracted from the Algebraic-Jacobian challenge; only the source cited by the
kept Čech-cohomology chapter is retained.

- `stacks-coherent.md` → `stacks-coherent.tex`: Stacks ch.30 "Cohomology of Schemes". Tags 02KE
  (Čech computes cohomology when intersections affine), `lemma-cech-cohomology-quasi-coherent-trivial`,
  02KG (Serre vanishing for qcoh on affines), `lemma-quasi-coherence-higher-direct-images-application`
  (`H^q(X,F)=H^0(S,R^q f_*F)` for affine S). Backs `def:cech_nerve`, `def:cech_complex`,
  `lem:cech_acyclic_affine`, comparison theorem.
- `homological-acyclic.md` → `homological-acyclic-derived.tex`, `homological-acyclic-homology.tex`:
  Stacks derived.tex + homology.tex — right-F-acyclic objects (0157), criterion (015C), Leray's
  acyclicity lemma (015E), enough acyclics (05TA), delta-functor background. Backs
  `Cohomology_AcyclicResolution.tex`.
- `stacks-cohomology.md` → `stacks-cohomology.tex`: Stacks ch. Cohomology — `lemma-describe-higher-direct-images`
  (01XJ, `R^if_*` is sheafification of `V↦H^i(f⁻¹V,F)`); `lemma-cech-vanish-basis` (01EO,
  Čech-to-cohomology on a basis). Backs `Cohomology_CechHigherDirectImage.tex`.

## Blueprint summary

- `Cohomology_AcyclicResolution.tex` — abstract acyclic-resolution comparison `RⁿG≅Hⁿ(GK•)` (Leray,
  Stacks 015E); P4, COMPLETE.
- `Cohomology_CechHigherDirectImage.tex` — consolidated chapter (covers `CechHigherDirectImage.lean`):
  Čech nerve/complex, push–pull functor, P3 standard-cover Čech vanishing, the P3b minimal torsor-free
  Čech↔derived bridge (`injective_cech_acyclic`, `ses_cech_h1`, `cech_to_cohomology_on_basis`,
  `affine_serre_vanishing`), P5a vanishing inputs, P5b comparison assembly (the protected goal).
- `Cohomology_HigherDirectImage.tex` — thin pointer: `R^if_*` via injective resolutions (the
  derived-functor definition `higherDirectImage` consumed by the goal).

## Prior critique status

- iter-010: `lem:cech_to_cohomology_on_basis` proof circular (term-acyclicity from homotopy alone) — addressed
- iter-010: P5a under-scoped / basis lemma treated as atomic — addressed
