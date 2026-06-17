# Blueprint-writer directive — iter-062 FIX (fast-path gate-clear)

Chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.

The iter-062 blueprint-reviewer FAILED the HARD GATE on TWO new build-target sub-lemmas you wrote this
iter. Fix ONLY these two statements + one NOTE conflict. Do NOT touch anything else. The planner has
pinned the exact Lean types from Mathlib (signatures below) — use them verbatim so the statements are
precise enough to formalize. Do NOT add/remove `\leanok`.

────────────────────────────────────────────────────────────────────────
## PINNED MATHLIB TYPES (use these — planner verified via loogle this iter)
────────────────────────────────────────────────────────────────────────

`SheafOfModules.pullback`:
  given `F : C ⥤ D` with `[F.IsContinuous J K]`, `S : Sheaf J RingCat`, `R : Sheaf K RingCat`,
  and  `φ : S ⟶ (F.sheafPushforwardContinuous RingCat J K).obj R`  with `[(SheafOfModules.pushforward φ).IsRightAdjoint]`,
  produces a functor  `SheafOfModules.pullback φ : SheafOfModules S ⥤ SheafOfModules R`.
  `SheafOfModules.instIsLeftAdjointPullback` makes it a LEFT ADJOINT (hence colimit-preserving).

`SheafOfModules.pullbackObjUnitToUnit`:
  `φ : S ⟶ (F.sheafPushforwardContinuous RingCat J K).obj R` (same hyps + the two `HasSheafCompose`
  instances) gives  `(pullback φ).obj (unit S) ⟶ unit R`.
  `SheafOfModules.instIsIsoPullbackObjUnitToUnitOfFinal` makes it an ISO when `[F.Final]`.

So `ψ_r` is, PRECISELY, a morphism of sheaves of rings
  `ψ_r : 𝒪_{U_i} ⟶ (F.sheafPushforwardContinuous RingCat J K).obj 𝒪_{V_i}`
where:
  - `F` is the CONTINUOUS functor between the opens-sites of `U_i` (the `X`-side affine open) and
    `V_i = φ.inv ⁻¹ᵁ U_i` (the `Y`-side image), induced by the homeomorphism underlying `φ` restricted
    to `U_i`. (`[F.IsContinuous]`, `[F.Final]` hold — `F` is an equivalence.)
  - `𝒪_{U_i} : Sheaf J RingCat` and `𝒪_{V_i} : Sheaf K RingCat` are the structure sheaves of the two
    sliced opens-sites (as `Sheaf _ RingCat`).
  - `[(SheafOfModules.pushforward ψ_r).IsRightAdjoint]` is required (the obligation the prover discharges).
  - `pullback ψ_r : SheafOfModules 𝒪_{U_i} ⥤ SheafOfModules 𝒪_{V_i}` then carries `X`-side modules over
    `U_i` to `Y`-side modules over `V_i`.

────────────────────────────────────────────────────────────────────────
## FIX 1 — `lem:slice_structureSheaf_hom` (must-fix #1)
────────────────────────────────────────────────────────────────────────
Rewrite the STATEMENT so it pins the Lean type of `ψ_r` exactly as above: name the continuous
opens-equivalence functor `F` (with `[F.IsContinuous]`, `[F.Final]`), state that `ψ_r` is a morphism
`𝒪_{U_i} ⟶ (F.sheafPushforwardContinuous RingCat _ _).obj 𝒪_{V_i}` of `Sheaf _ RingCat`, and that it
carries the instance `[(SheafOfModules.pushforward ψ_r).IsRightAdjoint]`. Drop the vague "over the slice
(over-category) picture" phrasing. The construction (proof sketch): `F` and the two structure sheaves
come from the scheme iso `φ` restricted to `U_i`; `ψ_r` is `φ.hom`'s structure-sheaf comparison
(`Scheme.Hom.toRingCatSheafHom`-style) restricted along that opens-equivalence, using the Beck–Chevalley
identity `Over.post _ ⋙ Over.forget = Over.forget ⋙ _` (`CategoryTheory.Over.post_forget_eq_forget_comp`,
rfl). Add `\uses{}` pointing at the Mathlib anchors actually used (the `sheafPushforwardContinuous`
structure-sheaf-hom constructor, `lem:pushforwardPushforwardEquivalence_mathlib` IF the opens-equivalence
is sourced from there, and any over-category unit-identity anchor). If a clean Mathlib anchor for the
`Scheme.Hom`→ring-sheaf-hom step does not exist as its own blueprint node, add a one-line `\mathlibok`
anchor block naming the Mathlib declaration (`\lean{...}`) and `\uses` it.

────────────────────────────────────────────────────────────────────────
## FIX 2 — `lem:pushforward_slice_pullback_iso` (must-fix #2)
────────────────────────────────────────────────────────────────────────
Rewrite so the LHS is concrete. State it as:
  `(SheafOfModules.pullback ψ_r).obj (H.over U_i)  ≅  (Φ.functor.obj H).over V_i`
i.e. the LHS is `pullback ψ_r` applied directly to `H.over U_i` (NO vague "H.over W transported" — the
`pullback ψ_r` functor IS the transport, and it goes `SheafOfModules 𝒪_{U_i} ⥤ SheafOfModules 𝒪_{V_i}`,
so `H.over U_i` is already in its domain). Name `ψ_r` via `\uses{lem:slice_structureSheaf_hom}`.
Proof sketch: assemble from `SheafOfModules.pullbackObjUnitToUnit ψ_r` (an ISO since `F` is final,
`instIsIsoPullbackObjUnitToUnitOfFinal`) together with the opens-equivalence object identity
`F.obj U_i = V_i` (state this as the rfl-or-eqToIso step — if `rfl`, say "`rfl` on the underlying opens";
if it needs `eqToIso`, say so and give the open-set equality `φ.inv ⁻¹ᵁ U_i = V_i`). REMOVE the bare
"holds definitionally" claim with no path: either name it as `rfl` on the opens (the prover verified
`e_op.functor.obj W = φ.inv ⁻¹ᵁ W` is `rfl` in iter-061 — cite that) or as an `eqToIso` of the named
open-set equality. Add `\uses` entries for the pullback-unit anchor (add a `\mathlibok` anchor block for
`SheafOfModules.pullbackObjUnitToUnit` / `instIsIsoPullbackObjUnitToUnitOfFinal` and `\uses` it).

────────────────────────────────────────────────────────────────────────
## FIX 3 — `lem:pushforward_commutes_restriction` contradictory NOTE (soon, do it now)
────────────────────────────────────────────────────────────────────────
This block carries BOTH "% NOTE: build target. The Lean declaration does not exist yet." AND
"% NOTE: superseded — ...retained as alternative/reference only." Resolve the conflict: it is superseded,
NOT an active build target. Remove the `\lean{AlgebraicGeometry.pushforward_commutes_restriction}` hint
line (or convert to `% formerly planned: AlgebraicGeometry.pushforward_commutes_restriction`) and the
"build target" NOTE, keeping only the "superseded / alternative-route" NOTE. Ensure nothing on a live
`\uses` chain references it (it is already excluded from `lem:pushforward_iso_preserves_qcoh`).

────────────────────────────────────────────────────────────────────────
## Out of scope
────────────────────────────────────────────────────────────────────────
- Do NOT edit any other lemma, the CSI chain, or any other chapter.
- Do NOT add/remove `\leanok`.
- Keep the `pullback ψ_r` route logic in `lem:pushforward_iso_preserves_qcoh` as-is (the reviewer
  PASSED its coherence) — you are only making the two leaf sub-lemmas precise.
