# Directive: strategy-critic — fresh-context review of the strategy (Route B keystone juncture)

Read these and nothing else (fresh-context discipline — do NOT read iter sidecars, task files, or
recent prover/review narrative):
- `.archon/STRATEGY.md` (verbatim — the current strategy).
- `references/summary.md` (the reference index for this subproject).
- Blueprint chapter titles + one-line topics: list `blueprint/src/chapters/*.tex` and read each
  chapter's first `\chapter{...}`/top comment to get its topic (do NOT read full proofs).

## Project goal (one paragraph)
Formalize, with zero inline `sorry` in its dependency cone and zero project axioms (kernel-only),
the protected theorem `AlgebraicGeometry.cech_computes_higherDirectImage`: for `f : X ⟶ S`
separated + quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover of `X`, an
isomorphism `Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` under
`[HasInjectiveResolutions X.Modules]`. The chosen path (Route A) reduces this to affine Serre
vanishing `H^q(affine, qcoh)=0` (02KG) via an acyclic-resolution comparison; 02KG in turn gates on
the affine structure theorem 01I8 (`F ≅ ~(Γ F)` on `Spec R`), which the strategy attacks via
"Route B" — the section-localization keystone.

## Focus for your verdict (but assess the whole strategy freshly)
The strategy has just reached the Route B keystone (`qcoh_section_isLocalizedModule`): for qcoh `F`
on `Spec R`, the section-restriction `Γ(Spec R,F)→Γ(D(f),F)` is `IsLocalizedModule (powers f)`.
The B-chain leaves (B0–B4) are done. The planner has surfaced a SOUNDNESS RISK (see STRATEGY
`## Open strategic questions` — "KEYSTONE descent non-circularity"): the span-cover descent appears
to need the per-cover-element identification `Γ(D(gⱼ),F)≅Γ(X,F)_{gⱼ}` (a sheaf-gluing/Čech-H⁰ step),
which the listed pieces may not supply.

Questions:
1. Is the overall Route A → 02KG → 01I8 → Route B decomposition still sound and matching the
   canonical Stacks skeleton (01HV/01I8/02KG/02KE/01EO)? Any structural mis-step?
2. Is the keystone soundness risk real and correctly diagnosed, and is the proposed resolution
   (reuse the project's P3 section-Čech machinery — `exact_of_isLocalized_span` — on the cover, with
   each tile `F_{(gⱼ)}` tilde-structured) the right strategic response, or is there a cleaner route
   (e.g. checking `IsIso F.fromTildeΓ` directly on the basis via `isIso_fromTildeΓ_iff` essImage)?
3. Any sunk-cost lock-in: is the project over-invested in the section-localization keystone when a
   different 01I8 route would be materially shorter — WITHOUT resurrecting the deliberately-avoided
   tilde base-change wall (`tilde_restrict_basicOpen`, Route P)?

Verdict: SOUND / CHALLENGE / REJECT, with specifics.
