# Blueprint-writer directive — FBC chapter, Seam-2/Seam-3 mechanism + helper pin

## Chapter
`blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (ONLY this chapter).

## Strategy slice
FBC-A proves the affine base-change lemma directly on global sections (Stacks 02KH part 2). The
section identity factors through three section-level mate lemmas: Seam 1 (`unit_value`, CLOSED),
Seam 2 (`fstar_reindex`), Seam 3 (`gstar_transpose`). The load-bearing tool is the conjugate (mate)
calculus on plain `conjugateEquiv`. Seam 2 is the generic-pullback-square pseudofunctor reindex that
transports the `(g')`-unit into the affine `Spec(ι_A)`-unit, then feeds Seam 1. iter-016 landed a NEW
axiom-clean helper `AlgebraicGeometry.pullbackPushforward_unit_comp` (the leg-reindex engine) but the
Seam-2 `sorry` persists because the two pullback legs sit in DEPENDENT positions.

## The iter-016 review (lean-vs-blueprint-checker `fbc`) flagged THREE chapter gaps — fix all three:

### Must-fix 1 — pin the landed helper (clears coverage debt)
Add a new `\begin{lemma}` block with
`\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` and label
`lem:pullbackPushforward_unit_comp`, placed in the "section-level mate computation" subsection
IMMEDIATELY BEFORE `lem:base_change_mate_fstar_reindex`. The lemma is FULLY PROVED, axiom-clean.
Statement (pseudofunctoriality of the pullback–pushforward unit): for composable scheme morphisms
`a : X₁ ⟶ X₂`, `b : X₂ ⟶ X₃` and a module `N` on the codomain `X₃`,
```
unit_b.app N ≫ (pushforward b).map (unit_a.app ((pullback b).obj N)) ≫ (pushforwardComp a b).hom.app N
  = unit_{a≫b}.app N ≫ (pushforward (a≫b)).map ((pullbackComp a b).inv.app N).
```
One-line informal proof: it is `CategoryTheory.unit_conjugateEquiv` for the composed adjunction
`(adj b).comp (adj a)` vs `adj (a≫b)`, rewritten by
`Scheme.Modules.conjugateEquiv_pullbackComp_inv` (which sends `(pullbackComp a b).inv` to
`(pushforwardComp a b).hom`) and `Adjunction.comp_unit_app`. Author Mathlib dependency anchors
(`\mathlibok`, with the real `\lean{}` targets) for `CategoryTheory.unit_conjugateEquiv`,
`CategoryTheory.Adjunction.comp_unit_app`, and `AlgebraicGeometry.Scheme.Modules.conjugateEquiv_pullbackComp_inv`
if they are not already pinned, and give them `\uses` edges. Then add
`\uses{lem:pullbackPushforward_unit_comp}` to `lem:base_change_mate_fstar_reindex`.

### Must-fix 2 — expand Seam 2 (`lem:base_change_mate_fstar_reindex`) for the dependent-type wall
The current `% RECIPE`/`% DEAD END` comments correctly diagnose that naive `rw [hfst]`/`rw [hsnd]`
fail with "motive is not type correct" because the two legs `pullback.fst`/`pullback.snd` appear in
DEPENDENT positions: the adjunction index, the `IsPullback.of_hasPullback … .w` proof inside
`pushforwardCongr`, the `gammaPushforwardIso` argument, and — crucially — INSIDE the type of the
opaque def `base_change_mate_codomain_read ψ φ M`. The chapter does NOT describe the resolution. Add a
rigorous, FORMALIZABLE prose proof that decomposes Seam 2 into named atomic sub-steps a fine-grained
prover can extract, along the lines the iter-016 prover recommended:
  (i) an ABSTRACT variable-legs restatement of `base_change_mate_codomain_read` (and of the relevant
      chain): state the codomain-read transport for GENERIC morphisms `g' f'` (with the cone-leg
      equalities `g' = e.hom ≫ Spec ι_A`, `f' = e.hom ≫ Spec ι_{R'}` supplied as hypotheses) so the
      legs become `subst`-able variables not pinned in dependent types;
  (ii) the Γ-collapse of the three TRANSPARENT pushforward coherences on global sections
       (`pushforwardComp_{hom,inv}_app_app = 𝟙`, `pushforwardCongr_hom_app_app = eqToHom`);
  (iii) the Seam-1 substitution: after `subst` of the legs, `pullbackPushforward_unit_comp` +
        `base_change_mate_unit_value` (Seam 1) + the Γ-collapse identify the four factors with
        `restrictScalars ψ` of the codomain-read transport of the unit value = `base_change_mate_inner_value`.
Give each of (i)/(ii)/(iii) enough mathematical detail (what is being identified with what, which
coherence collapses which factor) that the prover can turn each into a named lemma. State explicitly
that this restructuring is what makes the legs substitutable and avoids the motive error — it is NOT
a single `rw`.

### Must-fix 3 — expand Seam 3 (`lem:base_change_mate_gstar_transpose`)
Name the concrete counit coherence. The key fact: `pullback_spec_tilde_iso ψ` is built as
`((conjugateIsoEquiv adjL adjR).symm (gammaPushforwardNatIso ψ)).symm.app`, so its interaction with
the adjunction counit is NOT a bare `simp`/`rfl`. Describe the route: factor the base-change map via
`Adjunction.homEquiv_counit` (write `g^*(inner) ≫ counit`), then use the abstract `unit_conjugateEquiv`
/ counit-triangle identity for the COMPOSED adjunction `(tilde ⊣ Γ) ∘ (pullback ψ ⊣ pushforward ψ)` to
replace `g^*(inner)` by `extendScalars ψ ∘ ρ` (ρ = the inner value from Seam 2). State this as: the
counit-triangle identity reads `pullback_spec_tilde_iso ψ` composed with the counit of
`extendRestrictScalarsAdj ψ.hom` as the identity, which identifies `Γ(ε_g)` with the module-level
adjunction counit. Make it formalizable, not just conceptual.

## Citation discipline
Seam 2/3 are project-bespoke categorical bookkeeping (no external source) — the existing blocks carry
no `% SOURCE`; keep it that way. The Mathlib anchors get `\mathlibok` + `\lean{}` only.

## Out of scope
- Do NOT touch `affineBaseChange_pushforward_iso` (affine reduction) or
  `flatBaseChange_pushforward_isIso` (FBC-B) blocks beyond leaving them as-is.
- Do NOT add `\leanok` anywhere (deterministic sync owns it).
- Do NOT edit any other chapter.
