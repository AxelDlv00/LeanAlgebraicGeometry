# Blueprint-writer directive — AbelianVarietyRigidity.tex: promote the 𝔾_m-scaling shortcut to the PRIMARY genus-0 base-case proof

## Chapter to edit
`blueprint/src/chapters/AbelianVarietyRigidity.tex` (ONLY this chapter). `references/**`
read allowed if needed.

## Context
The previous writer pass (this iter) rewrote the genus-0 base case to a direct ℙ¹×𝔾
rigidity argument and surfaced a strictly cleaner close — the **𝔾_m-scaling shortcut** —
which it recorded in `rmk:base_case_fourth_route`, in `def:gaTranslationP1`'s σ_× part,
and as a "recommended simplification" tail of `lem:hom_from_Ga_trivial`'s proof. The plan
agent has DECIDED to adopt the scaling shortcut as the primary route (it uses ONLY the
already-proven Cor 1.5 + density, and avoids the `Hom(𝔾_a,A)=0` lemma whose standalone
proof needs "image of a group hom is a closed subgroup" — a deep Mathlib gap, the
previous writer's Finding 1).

The math is ALREADY written in the chapter; this pass RESTRUCTURES it so the scaling
shortcut is the stated primary proof, not a tail remark.

## The scaling-shortcut argument (the primary proof to install)
Let `f : ℙ¹ → A` be a morphism to an abelian variety, normalised `f(0) = η[A]`.
- `σ_× : ℙ¹ × 𝔾_m → ℙ¹`, `(x,λ) ↦ λ·x`, is a total scheme morphism (already in
  `def:gaTranslationP1`/its companion). It fixes `0`: `σ_×(0,λ) = 0`.
- `h := σ_× ≫ f : ℙ¹ ⊗ 𝔾_m → A` is total. Apply `lem:hom_additivity_over_product`
  (Cor 1.5; needs only the FIRST factor proper) with `V = ℙ¹` (proper), `W = 𝔾_m`,
  base points `v₀ = 0`, `w₀ = 1`. Then `h(0,1) = f(1·0) = f(0) = η[A]` ✓.
- V-axis restriction: `x ↦ h(x,1) = f(1·x) = f(x)`. W-axis restriction:
  `λ ↦ h(0,λ) = f(λ·0) = f(0) = η[A]` — CONSTANT, because `0` is a scaling fixed point.
- Cor 1.5 decomposes `h = (p ≫ f) · (q ≫ g)` with `g` the (constant `η`) W-axis
  restriction; the constant factor is the identity of the hom-group, so
  `h = p ≫ f`, i.e. `f(λ·x) = f(x)` for all `x ∈ ℙ¹`, `λ ∈ 𝔾_m`.
- Specialise `x = 1`: `f(λ) = f(1)` for all `λ ∈ 𝔾_m`, i.e. `f|_{𝔾_m}` is constant.
- `𝔾_m` is dense in `ℙ¹` and `A` is separated, so `f` is constant (the
  `ext_of_isDominant` / dominant-source separated-target handle already used by
  `rigidity_core`).

## What to change (precise)
1. **Make this the primary proof of the genus-0 base case.** The cleanest target is the
   proposition `prop:morphism_P1_to_AV_constant` (`\lean{morphism_P1_to_grpScheme_const}`)
   — "a morphism `ℙ¹ → A` is constant". Install the scaling-shortcut argument as ITS
   proof directly (it proves constancy in one shot, no intermediate "f|_{𝔾_a} additive"
   step). Update its `\uses{}` to `{lem:hom_additivity_over_product, def:gaTranslationP1}`
   plus whatever density/separatedness lemma label you cite (e.g. the `ext_of_isDominant`
   block in `Rigidity.tex` — use its real `\label`).
2. **Demote `lem:hom_from_Ga_trivial` (`morphism_Ga_to_av_const`) and
   `lem:hom_Ga_to_av_trivial` (`Hom(𝔾_a,A)=0`)** to OPTIONAL / not-on-the-genus-0-critical-
   path. Either: (a) keep `lem:hom_from_Ga_trivial` as an alternative-route remark with a
   clear "superseded by the 𝔾_m-scaling shortcut; retained as the classical Milne Prop 3.9
   argument" note and DROP it from the genus-0 `\uses` chain (nothing on the critical path
   should `\uses` it); or (b) if cleaner, fold its statement into a remark. Do NOT delete
   the `\lean{morphism_Ga_to_av_const}` target if it is still referenced by a downstream
   `\lean` decl — but if `prop:morphism_P1_to_AV_constant` is the live target, the genus-0
   `\uses` chain should run `thm:rigidity_genus0_curve_to_AV` → `prop:morphism_P1_to_AV_constant`
   → `{lem:hom_additivity_over_product, def:gaTranslationP1, <density lemma>}`, bypassing
   `lem:hom_from_Ga_trivial` and `lem:hom_Ga_to_av_trivial`.
3. **Keep `def:genus0_base_objects` and `def:gaTranslationP1`** (concrete ℙ¹/𝔾_m + σ_×) —
   but ensure the 𝔾_m scaling action `σ_×` is fully specified as a first-class definition
   (it is the load-bearing new ingredient now), not just a companion to the 𝔾_a translation.
   The 𝔾_a translation σ may be retained for the demoted additive route or trimmed.
4. **Update the chapter intro / §I.3 section intro / `rmk:cube_not_needed` /
   `rmk:base_case_fourth_route`** so the PRIMARY narrative is the 𝔾_m-scaling shortcut
   (Cor 1.5 + scaling fixed point + density). Keep `rmk:base_case_fourth_route` as the
   explanation of why no Thm 3.2 / no `Hom(𝔾_a,A)=0` is needed.
5. Keep `lem:rational_map_to_av_extends` demoted to Route-A-only (as the prior pass left it).
6. Ensure the `\uses` graph stays forward-acyclic and all `\cref`/`\uses` resolve.

## Citation discipline
- The scaling argument is an Archon-original simplification of Milne Prop 3.9/3.10; cite
  Milne Prop 3.9 for the underlying "rational → AV constant" fact (the verbatim quote is
  already in-tree). No new PDF quote required; if you add a `% SOURCE` note, mark the
  scaling variant as the project's own realisation.

## Out of scope
- Do NOT touch the proven rigidity chain / Cor 1.5 / Cor 1.2 statement+proof blocks.
- Do NOT touch the 3 deferred scaffold Lean targets' names.
- Do NOT add/remove `\leanok`/`\mathlibok`. No Lean tactic code.

## Report back
- The final genus-0 `\uses` chain (which labels are now on the critical path), the
  `\lean{}` names a prover must scaffold for the scaling route (expected: the ℙ¹/𝔾_m
  objects, `σ_×`, and the live constancy target), and any further strategy-modifying findings.
