# Blueprint-writer directive — `Picard_TensorObjSubstrate.tex` (D2′ telescope: retype step 7 + pin the linchpin)

You edit exactly ONE chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`. Two surgical edits in the
§ "The unit square (D2′): a mate-calculus telescope" region (around `lem:eta_bridge_unit_square`,
`lem:comp_homequiv_factor_sheafify_pullback`, `lem:leftadjointuniq_app_unit_eta`,
`lem:epsilon_presheaf_to_sheaf_unit`). Do NOT touch any other section. Do NOT add or remove `\leanok`/`\mathlibok`
markers (a deterministic phase manages `\leanok`). This material is Archon-original categorical mate-calculus —
NO external source, so NO `% SOURCE`/`% SOURCE QUOTE` lines are required; the blocks stand on the proof sketch.

## Background (why these two edits)
The D2′ obligation `IsIso (pullbackTensorMap f 𝒪 𝒪)` was atomized last iter into a 7-step telescope. As of
iter-248 the abstract part is **fully discharged in Lean**: step 3 (`compHomEquivFactor`) and step 4
(`leftAdjointUniqUnitEta`) are closed axiom-clean, and the feared "3-layer adjunction defeq wall" turned out to
hold definitionally (`rfl`). The whole obligation now bottoms out in ONE concrete residual (∗∗) inside the
assembly lemma `lem:eta_bridge_unit_square`. Two blueprint defects block the final `prove` pass:

1. **Step 7 (`lem:epsilon_presheaf_to_sheaf_unit`) is ill-typed as written.** It states the identity at the
   SHEAF level using `\varepsilon(\mathtt{pushforward}\,\varphi)` — i.e. `Functor.LaxMonoidal.ε` of the *sheaf*
   pushforward `SheafOfModules.pushforward φ`. Mathlib at the pinned commit has NO `Functor.LaxMonoidal` instance
   on the sheaf pushforward — only the **presheaf** one (`presheafPushforwardLaxMonoidal` on
   `PresheafOfModules.pushforward φ'`). So the LHS does not typecheck. (See the existing `% NOTE (iter-248 review)`
   already in that block, and `task_results/TensorObjSubstrate.md` step 7.)

2. **The `rfl` linchpin has no blueprint block.** The identity
   `sheafificationCompPullback φ = A.leftAdjointUniq B` is load-bearing (it is what makes step 4 mechanical) and
   reusable, but it is currently only an unpinned Lean decl. It should be a named lemma the telescope cites.

## EDIT 1 — Add a new lemma block for the `rfl` linchpin (place it immediately BEFORE `lem:leftadjointuniq_app_unit_eta`, since step 4 depends on it)

Add a `\begin{lemma}…\end{lemma}` + `\begin{proof}…\end{proof}` with:
- `\label{lem:sheafification_comp_pullback_eq_leftadjointuniq}`
- `\lean{AlgebraicGeometry.Scheme.Modules.sheafificationCompPullback_eq_leftAdjointUniq}`
- Statement (in project notation): the two ways of building the composite "sheafify-then-pullback" adjunction
  agree on the nose. Precisely, write `A` for the composite adjunction
  `(sheafification adjunction on X) ∘ (sheaf-level pullback–pushforward adjunction of φ)` and `B` for
  `(presheaf-level pullback–pushforward adjunction of φ') ∘ (sheafification adjunction on Y)`. Then the canonical
  comparison `sheafificationCompPullback φ` equals the left-adjoint-uniqueness isomorphism `A.leftAdjointUniq B`.
- Proof sketch: the two composite adjunctions have a **definitionally equal right adjoint**
  (`pushforward φ ⋙ forget_X ≡ forget_Y ⋙ pushforward φ'` — pushforward commutes with the forgetful to presheaves
  on the nose), so `A.leftAdjointUniq B` is defined, and the comparison map is **definitionally** the
  `sheafificationCompPullback` comparison. Hence the identity holds by reflexivity. (One sentence: "Both sides
  unfold to the same morphism; the equality is `rfl`." — but state it as mathematics, no Lean tactic strings.)

Then in `lem:leftadjointuniq_app_unit_eta`'s `\uses{}` (statement and/or proof), ADD
`lem:sheafification_comp_pullback_eq_leftadjointuniq` to the dependency list (it is used to rewrite
`sheafificationCompPullback φ` to `A.leftAdjointUniq B` before applying the homEquiv mate identity).

## EDIT 2 — Retype `lem:epsilon_presheaf_to_sheaf_unit` (step 7) to a `.val`-level identity

Keep the `\label{lem:epsilon_presheaf_to_sheaf_unit}` and the `\lean{…epsilonPresheafToSheafUnit}` pin. DELETE the
`% NOTE (iter-248 review)` block (it is being addressed by this retype). Replace the ill-typed sheaf-`ε`
statement with the genuine content:

- **Statement (project notation, `.val`-level):** The presheaf-level lax-monoidal unit comparison
  `ε(pushforward φ')` and the sheaf-level structure-sheaf unit comparison `unitToPushforwardObjUnit φ` agree as
  maps of *underlying presheaves* — i.e. after applying the forgetful `(-).val` (sheaf → presheaf of modules),
  their components coincide. Concretely, on every section both act as `φ.hom.app` (the ring map underlying φ):
  `(unitToPushforwardObjUnit φ).val.app X a = φ.hom.app X a`, and the presheaf unit comparison
  `ε(pushforward φ')` has the same value on sections. State the identity as the equality of the two
  presheaf-level morphisms (the `.val` images), NOT as a sheaf-level `Functor.LaxMonoidal.ε` equation.
- Add a sentence noting the **exact Lean form is the `.val`-level (underlying-presheaf) reconciliation**, since
  there is no `LaxMonoidal` instance on the sheaf pushforward; the presheaf lax unit
  `Functor.LaxMonoidal.ε (PresheafOfModules.pushforward φ')` is the one that exists, and it is reconciled with
  the sheaf-level `unitToPushforwardObjUnit φ` through the sheafification ↔ pushforward compatibility.
- **Proof sketch:** both presheaf-level maps are, on each section, the single ring map `φ.hom.app X`
  (the presheaf lax unit of a pushforward is the structure-map comparison `𝒪 → φ_*𝒪`, and
  `unitToPushforwardObjUnit` is the same comparison by construction — its value is `φ.hom.app X` by
  `unitToPushforwardObjUnit_val_app_apply`). Equality of presheaf morphisms is checked sectionwise, so the two
  agree. Tracing the sheafification reconciliation backwards then identifies this with the step-6 presheaf head
  `ε(pushforward φ')`, closing (∗∗).
- Update `\uses{}` accordingly: keep `lem:unitToPushforwardObjUnit_comp`; the presheaf lax-monoidal structure
  reference is fine to keep if a matching `\label` exists (verify it does — if `lem:presheaf_pushforward_laxmonoidal`
  has no `\label` in this tree, drop it from `\uses{}` rather than leave a broken edge).

## Out of scope
- Do NOT modify steps 1–6 blocks, `lem:comp_homequiv_factor_sheafify_pullback`, the assembly transposition prose
  of `lem:eta_bridge_unit_square` beyond adding the linchpin to its `\uses{}` if it cites step 4's chain, or any
  D3′/D4′ material.
- Do NOT touch `exists_tensorObj_inverse` blocks, the off-path full-monoidal route-(e) apparatus, or any other
  chapter.
- No Lean tactic strings in prose. No `\leanok`.

## Report back
List the two edits made, the exact `\label`/`\lean` of the new linchpin block, confirmation that the step-7 block
no longer references a sheaf-level `ε`, and any `\uses{}` edge you dropped because its target `\label` was absent.
