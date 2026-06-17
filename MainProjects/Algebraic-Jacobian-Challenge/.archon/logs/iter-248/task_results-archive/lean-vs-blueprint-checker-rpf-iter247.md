# Lean ↔ Blueprint Check Report

## Slug
rpf-iter247

## Iteration
247

## Files audited
- Lean: `AlgebraicJacobian/Picard/RelPicFunctor.lean`
- Blueprint: `blueprint/src/chapters/Picard_RelPicFunctor.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup}` (chapter: `lem:rel_pic_sharp_groupoid`)
- **Lean target exists**: yes — `noncomputable instance addCommGroup {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) : AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))` at line 393.
- **Signature matches**: yes — the instance gives `AddCommGroup` on the iso-class quotient, consistent with the lemma prose.
- **Proof follows sketch**: **partial / diverges**. The blueprint describes a 4-step construction: Step 1 (abelian group on carrier), Step 2 (pullback homomorphism `π_T^*` making `H_T := π_T^* Pic(T)` a subgroup), Step 3 (setoid reconciliation, showing the iso-class relation = quotient-by-`H_T` relation), Step 4 (transport). The Lean implementation does **only Step 1**: it builds `AddCommGroup` directly on the iso-class quotient `Pic(C ×_S T)` (which equals `Quotient (preimage_subgroup ...)` because `preimage_subgroup` is the iso-class relation, **not** quotient-by-`H_T`). Steps 2–4 are not implemented. The blueprint NOTE block at tex lines 119–136 acknowledges this carrier caveat explicitly. The construction is mathematically correct for what it builds (the tensor-product Picard group on loc-triv iso-classes), but it is **not** the quotient `Pic(C×T)/H_T` the lemma statement implies.
- **notes**: The only `sorry` is upstream (`Modules.exists_tensorObj_inverse`, `TensorObjSubstrate.lean:672`); no local sorry. The `\leanok` marker on the statement block is correct (`sync_leanok` criterion: "at least a sorry present"). The `\leanok` marker is absent from the proof block — but only because of the broken `\uses{}` syntax (see Red Flags §2 below); the proof is sorry-containing so the absence of proof-block `\leanok` is correct by accident.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp}` (chapter: `def:rel_pic_sharp`)
- **Lean target exists**: yes — `noncomputable def PicSharp {k : Type u} [Field k] (_C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 _C.hom] [IsProper _C.hom] : (Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1}` at line 491.
- **Signature matches**: yes — type is `(Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1}`, consistent with the functor `(Sch/k)^op → Ab` that the definition describes.
- **Proof follows sketch**: **no**. Body is `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))` — the constant functor at the trivial group `PUnit`. The definition requires `T ↦ Pic(C ×_k T) / π_T^* Pic(T)` with non-trivial morphism action. This is a **weakened-wrong body**. Docstring at lines 476–490 explicitly labels it "a sorry-free placeholder."
- **notes**: The stated gate (iter-198 doc: "open while file-local `addCommGroup` sorry is open") is **no longer valid** as of iter-247: `addCommGroup` is now a real construction. The gate description in the docstring is stale. The real remaining blocker is `PicSharp.functorial` (the morphism action), which is still `:= 0`. Statement `\leanok` is set by `sync_leanok` (declaration compiles with 0 sorries).

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.functorial}` (chapter: `lem:rel_pic_sharp_functorial`)
- **Lean target exists**: yes — `noncomputable def functorial {S C T T' : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S) (πT' : T' ⟶ S) (g : T' ⟶ T) (_hg : πT' = g ≫ πT) : Quotient (RelPicPresheaf.preimage_subgroup πC πT) →+ Quotient (RelPicPresheaf.preimage_subgroup πC πT')` at line 536.
- **Signature matches**: yes — type is an `AddMonoidHom` (written `→+`) between quotients, consistent with "set map upgrades to a group homomorphism."
- **Proof follows sketch**: **no**. Body is `:= 0`, the zero `AddMonoidHom`. The lemma claims the map is the actual pullback-descended homomorphism `g_C^*`. This is a **placeholder body**.
- **notes**: Docstring at lines 523–535 labels it "zero AddMonoidHom body ... NOT the pullback-descended homomorphism." Statement `\leanok` is set by `sync_leanok`. The proof block has `\leanok` at blueprint lines 348–350 (`\begin{proof}\n\n\leanok`), which reflects that the zero-body proof compiles with no sorry — technically correct for `sync_leanok`, but the mathematical content is wrong.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.presheaf}` (chapter: `thm:rel_pic_sharp_presheaf`)
- **Lean target exists**: yes — `noncomputable def presheaf {k : Type u} [Field k] (_C : Over (Spec (.of k))) [SmoothOfRelativeDimension 1 _C.hom] [IsProper _C.hom] : (Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1}` at line 585.
- **Signature matches**: yes — type `(Over (Spec (.of k)))ᵒᵖ ⥤ AddCommGrpCat.{u+1}` matches the claimed presheaf of abelian groups.
- **Proof follows sketch**: **no**. Body is `PicSharp _C` — it re-exports the constant-functor placeholder from `PicSharp`. The theorem claims the presheaf is assembled from the pullback-descended functorial action.
- **notes**: Cascade: both the object and morphism actions are wrong (placeholder `PicSharp` + zero `functorial`). Statement `\leanok` is set by `sync_leanok`. Proof-block `\leanok` at blueprint lines 408–411 reflects the sorry-free placeholder body — same situation as `functorial`.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.etSheaf}` (chapter: `def:rel_pic_etale_sheafification`)
- **Lean target exists**: yes — `noncomputable def PicSharp.etSheaf ... : Sheaf J AddCommGrpCat.{u+1}` at line 650.
- **Signature matches**: yes — `Sheaf J AddCommGrpCat.{u+1}` for parameter `J : GrothendieckTopology (Over (Spec (.of k)))`.
- **Proof follows sketch**: **partial / cascades**. Body is `(CategoryTheory.presheafToSheaf J AddCommGrpCat.{u+1}).obj (PicSharp.presheaf _C)`. The sheafification machinery is correct, but the input presheaf `PicSharp.presheaf _C` is the constant-functor placeholder, so this is the sheafification of the wrong presheaf. Statement `\leanok` set by `sync_leanok`.
- **notes**: The Lean API for sheafification is correctly cited. Blueprint NOTE at tex lines 492–507 explicitly documents that the input presheaf is wrong. This is a cascade from `PicSharp`/`presheaf` placeholders.

---

### `\lean{AlgebraicGeometry.Scheme.PicSharp.etSheaf_group_structure}` (chapter: `thm:rel_pic_etale_sheaf_group_structure`)
- **Lean target exists**: yes — `theorem etSheaf_group_structure ... : Nonempty (PicSharp.presheaf C ⟶ (PicSharp.etSheaf C J).obj)` at line 703.
- **Signature matches**: yes — type is `Nonempty (...)` matching the "hom-set nonempty" weakening stated in the theorem.
- **Proof follows sketch**: **partial**. Body is `⟨0⟩` — the zero natural transformation as the `Nonempty` witness. The theorem statement is deliberately weakened to `Nonempty` existence (not the canonical sheafification unit). The blueprint explicitly documents this weakening and says the full universal property is `thm:rel_pic_etale_sheaf_unit_canonical` (no Lean pin). The proof-block `\leanok` at blueprint lines 587–590 is correct (no sorry, sorry-free zero witness).
- **notes**: The weakening to `Nonempty` is consistent between the Lean type and the blueprint statement; this is a deliberate deferral, not a covert weakening. No red flag beyond the pre-existing deferral.

---

## Red Flags

### Placeholder / suspect bodies

- `PicSharp` (line 491–494): body is `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))` — the constant functor at the trivial group. Blueprint `def:rel_pic_sharp` claims this is the relative Picard functor `T ↦ Pic(C ×_k T) / π_T^* Pic(T)`. **Weakened-wrong definition.**

- `PicSharp.functorial` (line 536–541): body is `:= 0`. Blueprint `lem:rel_pic_sharp_functorial` claims this is the pullback-descended group homomorphism `g_C^*`. **Placeholder body.**

- `PicSharp.presheaf` (line 585–588): body is `PicSharp _C`, re-exporting the constant-functor placeholder. **Cascading placeholder.**

- `PicSharp.etSheaf` (line 650–654): sheafification of the wrong (placeholder) presheaf. **Cascading wrong body.**

### Excuse-comments

- `RelPicFunctor.lean:476–490` (docstring of `PicSharp`): "This is a sorry-free placeholder used while the file-local `addCommGroup` sorry in §1 is open." The stated gate (`addCommGroup` sorry in §1) is **no longer valid as of iter-247** — `addCommGroup` is now a real construction. The docstring is stale and should be updated.

- `RelPicFunctor.lean:523–535` (docstring of `PicSharp.functorial`): "the body is the zero AddMonoidHom ... NOT the pullback-descended homomorphism this lemma describes." Classic excuse-comment on a placeholder body.

- `RelPicFunctor.lean:572–580` (docstring of `PicSharp.presheaf`): "the body re-exports `PicSharp _C` ... it is NOT the canonical presheaf assembled from the pullback-descended functorial action." Excuse-comment.

### Blueprint syntax bug — `\leanok` inside `\uses{}`

- `Picard_RelPicFunctor.tex:143–150` (proof of `lem:rel_pic_sharp_groupoid`): The `\leanok` command appears **inside** the `\uses{...}` braces, between `def:pullback_along_projection,` and `thm:relative_pic_quotient_well_defined`:
  ```latex
  \begin{proof}
    \uses{def:line_bundle_on_product, def:pullback_along_projection,
    \leanok
      thm:relative_pic_quotient_well_defined, lem:tensorobj_lift_onproduct,
      ...}
  ```
  The leanblueprint parser treats `\leanok\n    thm:relative_pic_quotient_well_defined` as a single invalid dependency label. The blueprint-doctor flags it as `\uses{\leanok\n    thm:relative_pic_quotient_well_defined}` — no matching `\label`. As a result:
  1. The `thm:relative_pic_quotient_well_defined` dependency is **lost** from the dependency graph for this proof (absorbed into the invalid combined token).
  2. The `\leanok` proof-block marker is not recognized (it is inside `\uses{...}`, not at the start of the proof body).
  
  **About the intended target label:** `thm:relative_pic_quotient_well_defined` **does exist** — it is defined at `blueprint/src/chapters/Picard_LineBundlePullback.tex:331`. The label is not undefined in the project; it is only "undefined" from the parser's perspective because of the broken syntax that embeds `\leanok` before it.
  
  **Note on the correct fix:** The `\leanok` should be **removed entirely** from this context (not moved outside `\uses{}`), because the proof of `lem:rel_pic_sharp_groupoid` is sorry-containing (it transitively calls `Modules.exists_tensorObj_inverse`, the upstream project-deferred sorry). A proof-block `\leanok` would be incorrect here. The correct structure is:
  ```latex
  \begin{proof}
    \uses{def:line_bundle_on_product, def:pullback_along_projection,
      thm:relative_pic_quotient_well_defined, lem:tensorobj_lift_onproduct,
      ...}
    [proof text...]
  \end{proof}
  ```
  (no `\leanok` on the proof block, since the proof is sorry-containing).

---

## Unreferenced declarations (informational)

- `AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct` (line 198): noncomputable def moved from `TensorObjSubstrate.lean` to `RelPicFunctor.lean` in iter-247 to break the import cycle. **No `\lean{...}` pin in this chapter.** The corresponding blueprint lemma `lem:tensorobj_lift_onproduct` belongs to the TensorObjSubstrate chapter. The move may have broken or left stale the `\lean{...}` pin in `Picard_TensorObjSubstrate.tex` for this declaration — this is a cross-file issue outside this checker's scope, flagged for the code-audit/blueprint-review agents.
- `PicSharp.isLocallyTrivial_unit` (private, line 285): helper, acceptable (no pin expected).
- `PicSharp.pInverseUnique` (private, line 302): helper, acceptable.
- `PicSharp.relTensorObj` (private, line 315): helper, acceptable.
- `PicSharp.relAdd` (private, line 321): helper, acceptable.
- `PicSharp.relNeg` (private, line 334): helper, acceptable.

---

## Blueprint adequacy for this file

- **Coverage**: 6/6 blueprint-pinned declarations have `\lean{...}` targets in the Lean file. All targets exist. 1 unreferenced substantive declaration (`Modules.tensorObjOnProduct`, moved from TensorObjSubstrate) has no pin in this chapter.

- **Proof-sketch depth**: **under-specified for the current implementation**. The proof sketch for `lem:rel_pic_sharp_groupoid` (tex lines 143–239) describes a 4-step construction (group on carrier → `π_T^*` homomorphism → setoid reconciliation → transport). The current Lean `addCommGroup` implements only Step 1 and skips Steps 2–4 entirely (because the carrier `preimage_subgroup` is the iso-class relation, not the `Quotient`-by-`H_T` relation; no `H_T`-quotient step is needed at the current carrier). The blueprint NOTE at tex lines 119–136 documents this divergence, but it is embedded in a `%` comment, not in the proof sketch itself. A prover reading only the proof sketch would be misled about what to build. This is a genuine adequacy issue for future provers.

- **Hint precision**: **precise** — all six `\lean{...}` names exactly match the declaration names on disk. No wrong Mathlib predicate.

- **Generality**: **matches need** — no parallel API duplication introduced (the iter-247 import-cycle fix correctly routed through the upstream substrate).

- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. **Fix the `\leanok`-in-`\uses{}` bug** in the proof of `lem:rel_pic_sharp_groupoid` (tex line 145): remove the embedded `\leanok` from inside `\uses{...}`. Do NOT add `\leanok` to the proof block (the proof is sorry-containing via the upstream `Modules.exists_tensorObj_inverse`).
  2. **Add a NOTE to the proof sketch of `lem:rel_pic_sharp_groupoid`** (prominently, in the proof body, not only a `%` comment) that Steps 2–4 describe the future construction once `preimage_subgroup` is refined to quotient-by-`H_T`; the current Lean implementation realizes Step 1 only (the full `Pic(C ×_S T)` tensor-product group on iso-class quotient, which equals `Quotient (preimage_subgroup)`).
  3. **Update the stale NOTE** in the `def:rel_pic_sharp` NOTE block (tex lines ~281–296): the stated gate ("file-local `addCommGroup` sorry") is no longer valid as of iter-247; the gate has partially lifted. The real remaining gate is `PicSharp.functorial` (morphism action). Same for the NOTE in `lem:rel_pic_sharp_functorial` and `thm:rel_pic_sharp_presheaf`.
  4. **Add or update `\lean{...}` pin** for `Modules.tensorObjOnProduct` in the TensorObjSubstrate chapter (cross-file, outside this chapter) to reflect the move.

---

## Severity summary

| Finding | Severity |
|---|---|
| `PicSharp` — constant-functor placeholder body, stale gate description | **must-fix-this-iter** |
| `PicSharp.functorial` — zero AddMonoidHom placeholder | **must-fix-this-iter** |
| `PicSharp.presheaf` — re-exports placeholder | **must-fix-this-iter** |
| `PicSharp.etSheaf` — sheafifies wrong (placeholder) presheaf | **must-fix-this-iter** |
| `\leanok` inside `\uses{}` in proof of `lem:rel_pic_sharp_groupoid` | **major** (breaks `thm:relative_pic_quotient_well_defined` dependency edge; does not introduce a wrong `\leanok` marker since the parser ignores the embedded one) |
| Proof sketch divergence: Steps 2–4 described but not implemented | **major** (misleading for future provers; documented only in `%` comments) |
| `Modules.tensorObjOnProduct` has no pin in this chapter after the move | **minor** (informational; cross-file scope) |
| `PicSharp.etSheaf_group_structure` — `Nonempty` weakening, zero witness | pre-existing, deliberate deferral — **not an iter-247 regression** |

**Overall verdict:** Four pre-existing must-fix-this-iter placeholders (`PicSharp`, `functorial`, `presheaf`, `etSheaf` cascade) and one major blueprint syntax bug (`\leanok` inside `\uses{}`); iter-247's `addCommGroup` construction is genuinely real and axiom-clean modulo one upstream sorry, but the functor-builder layer above it remains entirely unimplemented.
