# Strategy Critic Directive

## Slug
iter002

## Project goal

Formalize and prove the protected, frozen-signature theorem
`AlgebraicGeometry.cech_computes_higherDirectImage`: for a separated quasi-compact morphism
`f : X ⟶ S` of schemes, a quasi-coherent sheaf `F` on `X`, and a finite affine open cover
`𝒰` of `X`, there is (in the weak existence form) an isomorphism
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` for every `i`, under
`[HasInjectiveResolutions X.Modules]`, where
`higherDirectImage f i F = ((pushforward f).rightDerived i).obj F` is the i-th higher direct
image. Zero inline `sorry` in the dependency cone, zero project axioms, kernel-only axioms.
This is the Čech computation of higher direct images (Stacks Tag 02KE specialized to the weak
existence form). Extracted as a standalone subproject from the Algebraic-Jacobian challenge.

## Strategy under review

<STRATEGY.md verbatim follows>

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
| P1 `pushPullMap_comp` (functor law) | ACTIVE | ~1–2 | ~60–120 | `conjugateEquiv_comp`, `conjugateEquiv_pullbackComp_inv`, `pseudofunctor_associativity` | DEFINITIONAL coherence; prove via MATE calculus (pullback side), not pushforward-side `erw` grind. Recipe in `analogies/pushpull-functoriality.md`. |
| P2 `CechNerve`/`CechComplex` assembly | NEXT (needs P1) | ~1 | ~30–80 | `Over.lift`, `CosimplicialObject.whiskering`, `alternatingCofaceMapComplex` | once `G` is a functor, nerve = `coverCechNerve` lifted to `(Over X)ᵒᵖ ⥤ X.Modules` then `G`; plumbing already in file |
| P3 affine acyclicity (`CechAcyclic.affine`) | NEXT (parallel) | ~3–6 | ~200–500 | standard-cover Čech complex = localisations; prime-local contracting homotopy; `isZero` via localisation | building the explicit localisation description + module homotopy from scratch for `Scheme.Modules` |
| P4 abstract acyclic-resolution lemma (Leray's acyclicity, Stacks 015E) | NEXT (parallel) | ~3–5 | ~200–450 | `InjectiveResolution.isoRightDerivedObj`, `isZero_rightDerived_obj_injective_succ`, `rightDerivedZeroIsoSelf` | new file `AcyclicResolution.lean`. **Mathlib has NO LES / δ-functor for `Functor.rightDerived`** — build via comparison-of-resolutions (acyclic vs injective resolution is a `G`-quasi-iso), NOT a hand-built LES |
| P5 comparison assembly | LAST (needs P2,P3,P4) | ~2–4 | ~100–300 | the above + termwise `f_*`-acyclicity of `Cᵖ` | needs: augmented Čech complex is a resolution; relative affine vanishing `R^i(affine)_*=0`; `R^q(jₛ)_*=0` for affine open immersions into separated `X` |

## Routes

### Route A — acyclic-resolution comparison (CHOSEN)
The augmented Čech complex `0 → F → C⁰ → C¹ → ⋯` on `X` (`Cᵖ = ∏ (j_s)_*(F|_{U_s})` over
`(p+1)`-fold intersections) is (i) a resolution of `F` and (ii) termwise `(pushforward f)`-
acyclic, because each intersection is affine (relative Serre vanishing, P3). The abstract
homological-algebra theorem "a `G`-acyclic resolution computes `G.rightDerived`" (P4, built
by dimension-shifting from Mathlib's `InjectiveResolution.isoRightDerivedObj`) then gives
`Hⁱ(f_* C•) = Hⁱ(CechComplex) ≅ (pushforward f).rightDerived i F` directly — ONE abstract
lemma, NO spectral sequences. This is the standard Cartan–Leray acyclic-cover proof of the
existence statement; it folds P3 in as its acyclicity input.

### Route B — two spectral sequences (REJECTED, fallback only)
The literal Stacks 02KE route: a Čech-to-derived spectral sequence plus the Leray spectral
sequence for `Scheme.Modules`. Rejected: both spectral sequences are absent from Mathlib
(multi-thousand-LOC to build), and the Leray degeneration additionally needs quasi-coherence
of `R^q f_* F` (`lemma-quasi-coherence-higher-direct-images`, itself non-trivial via relative
Mayer–Vietoris). Strictly heavier than Route A for the same `Nonempty (… ≅ …)` goal. Kept on
record only as a fallback if Route A's abstract lemma proves unexpectedly hard.

## Open strategic questions

- P4: pick the build route for Leray's acyclicity (Stacks 015E) given Mathlib lacks an LES/
  δ-functor for `Functor.rightDerived`. Preferred (per blueprint-writer): compare the acyclic
  resolution `J•` to an injective resolution `I•` of `A`; `isZero_rightDerived_obj_injective_succ`
  shows the comparison `G(J•) → G(I•)` is a `G`-quasi-iso, then `isoRightDerivedObj` transports.
  Fallback: build the δ-functor LES from the horseshoe/snake lemma. DECIDE before scaffolding.
- P3: exact Mathlib names for prime-local exactness (`algebra-lemma-characterize-zero-local`
  analog, e.g. `Module.isZero` / localization-faithfulness) — verify before dispatching.
- P5: `lem:cech_to_cohomology_on_basis` (`cohomology-lemma-cech-vanish-basis`) — confirm
  whether Mathlib provides a faithful version for `Scheme.Modules` (→ `\mathlibok` anchor) or it
  must be built; its standalone statement is in Stacks `cohomology.tex`, not yet in `references/`.
- P5 (resolved): termwise `(pushforward f)`-acyclicity reduces cleanly to affine Serre
  vanishing via Stacks `lemma-relative-affine-vanishing` after localising to affine `S`
  (blueprint-writer confirmed; no strategy change).

## Mathlib gaps & new material

Gaps to fill (project-side, Mathlib lacks):
- General "`G`-acyclic resolution computes `G.rightDerived`" (Leray's acyclicity, P4) — only the
  injective-resolution case exists; Mathlib also lacks any LES/δ-functor for `Functor.rightDerived`.
- Standard-cover Čech complex as the complex of localisations + its prime-local contracting
  homotopy / positive-degree exactness (P3).
- Relative affine vanishing `R^i(affine morphism)_* = 0 (i>0)` and `R^q(jₛ)_* = 0` for affine
  open immersions into separated `X`, for `Scheme.Modules` (P5, termwise acyclicity).
- Čech-to-cohomology-on-a-basis (`cohomology-lemma-cech-vanish-basis`) for `Scheme.Modules` (P3/P5).

New project material:
- push–pull functor `G : (Over X)ᵒᵖ ⥤ X.Modules`, `p ↦ p_* p^* F` (`pushPullObj`/`pushPullMap`
  + functor laws) — keep hand-rolled (no Mathlib straightening).
- `CechNerve` / `CechComplex` / `CechAcyclic.affine`.
- `AcyclicResolution.lean`: abstract acyclic-resolution comparison.
- comparison assembly `cech_computes_higherDirectImage` via Route A.

## References index

This subproject was extracted from the Algebraic-Jacobian challenge; only the source cited by
the kept Čech-cohomology chapter is retained.

| File | Description |
| ---- | ----------- |
| `stacks-coherent.md` → `stacks-coherent.tex` | Stacks ch.30 "Cohomology of Schemes". Tags 02KE (Čech computes cohomology when all intersections affine), 02KG (Serre vanishing for quasi-coherent on affines), `lemma-quasi-coherence-higher-direct-images-application` (`H^q(X,F)=H^0(S,R^q f_*F)` for affine `S`). Backs the Čech nerve/complex/acyclic and the comparison theorem. |
| `homological-acyclic.md` → `homological-acyclic-derived.tex`, `homological-acyclic-homology.tex` | Stacks `derived.tex` + `homology.tex`: right-F-acyclic objects (Tag 0157), criterion via vanishing of higher derived functors (Tag 015C), Leray's acyclicity lemma (Tag 015E), enough-acyclics (Tag 05TA), delta-functor background (010Q–010U). Backs `Cohomology_AcyclicResolution.tex`. |

## Blueprint summary

- `Cohomology_HigherDirectImage.tex` — defines `higherDirectImage f i F := ((pushforward f).rightDerived i).obj F` (the RHS of the goal). Covers `HigherDirectImage.lean`.
- `Cohomology_AcyclicResolution.tex` — the one abstract scheme-independent piece: right-`G`-acyclic objects (`def:right_acyclic`), dimension-shift across an acyclic SES (`lem:acyclic_dimension_shift`), and the comparison theorem "an acyclic resolution computes `R^nG`" (`lem:acyclic_resolution_computes_derived`); three `\mathlibok` Mathlib anchors. Covers `AcyclicResolution.lean` (file not yet scaffolded). Route A.
- `Cohomology_CechHigherDirectImage.tex` — the geometric construction: push–pull functor `G` and its functor laws (`lem:push_pull_id`/`lem:push_pull_comp`), `CechNerve`/`CechComplex`, affine acyclicity (`lem:cech_acyclic_affine` split into Čech-complex vanishing + `lem:affine_serre_vanishing` + `lem:cech_to_cohomology_on_basis`), and the comparison assembly `lem:cech_computes_cohomology` (the protected goal). Covers `CechHigherDirectImage.lean`. Route A.

## Prior critique status

- iter-001: comparison route undecided/undecomposed (two spectral sequences as primary) — addressed (pivoted to Route A acyclic-resolution, decomposed into P1–P5 with iter/LOC estimates).
- iter-001: STRATEGY.md format NON-COMPLIANT (non-canonical headings) — addressed (rewritten to canonical skeleton).

NOTE TO CRITIC: the iter-001 rewrite that addressed both prior challenges was never itself
re-validated by you (you ran on the PRE-rewrite strategy). Please treat this as a fresh audit
of the current Route A strategy. Of particular interest: (a) is the P4 build route
(comparison-of-resolutions, given Mathlib lacks an LES/δ-functor for `Functor.rightDerived`)
mathematically sound and free of phantom prerequisites? (b) does Route A's reliance on the
same abstract acyclic-resolution lemma + affine acyclicity constitute genuine progress over
Route B, or does it defer the same hard infrastructure under a new name? (c) are the P3/P4/P5
effort estimates honest given each builds substantial `Scheme.Modules`-specific homological
infrastructure absent from Mathlib?
