# Lean-scaffolder directive — SNAP tensor chain next targets (iter-077)

Target file: `AlgebraicJacobian/Picard/SectionGradedRing.lean` (currently sorry-free; the crux
`isIso_sheafification_whiskerRight_unit` + feeder `ztensor_whisker_localIso` were CLOSED
axiom-clean iter-066).

Create, in namespace `AlgebraicGeometry.Scheme.Modules`, public sorry-bearing decls matching
the chapter `blueprint/src/chapters/Picard_SectionGradedRing.tex` exactly (names from the
`\lean{}` pins):

1. `tensorObjAssoc` — per `cor:sheafTensorObjAssoc` (chapter ~L1076): the associator iso
   `(A ⊗ B) ⊗ C ≅ A ⊗ (B ⊗ C)` for the sheaf tensor `sheafTensorObj`. `noncomputable def`
   returning the Iso, body `sorry`.
2. `tensorPowAdd` — per `lem:sheafTensorPow_add` (chapter ~L1155): the comparison
   `L^⊗n ⊗ L^⊗m ≅ L^⊗(n+m)` for `sheafTensorPow`. `noncomputable def`, body `sorry`.
3. `sectionsMul_assoc_unit` — per `lem:sectionMul_coherent` (chapter ~L1313) ONLY IF its
   prerequisites (`sectionMul` per `def:sectionMul`, `moduleUnit`) already exist in Lean
   (check with lean_local_search). If absent, SKIP and say so in the report.

Planner-strategy comment to inject above each sorry (verify lemma paths with local search):
- Associator route: `sheafTensorObj` is the sheafification of the presheaf tensor; both
  iterated sheaf tensors compare to the sheafified TRIPLE presheaf tensor via the now-proven
  `isIso_sheafification_whiskerRight_unit` (whiskered sheafification units are isos); the
  presheaf-level associator (`PresheafOfModules.monoidalCategory`) then descends. Full informal
  proof in the chapter block (L1076ff) and route context in `analogies/snap-assoc.md`.
- tensorPowAdd: induction on `m` via the associator + the `m = 0` right-unitor case
  (chapter proof block).
- Carrier idioms (MUST quote in the comment): abelian-group category is `AddCommGrpCat` NOT
  `AddCommGrp`; any `have` mentioning `P ⊗ Q` must spell
  `MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q`; defeq-tolerant term forms over
  simp/rw under the diamond (see "Load-bearing tricks" in
  `.archon/logs/iter-066/task_results-archive/AlgebraicJacobian_Picard_SectionGradedRing.lean.md`).

Constraints: file must still compile (verify with diagnostics or `lake build`); do not modify
any existing declaration or proof; place the new decls after the crux section; signatures must
faithfully render the chapter statements (universe/instance arguments as the existing
sheafTensorObj/sheafTensorPow API dictates).
