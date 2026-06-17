# Session 261 (iter-261) — review summary

## Metadata
- **Iteration / session:** 261
- **Global sorry count:** unchanged-to-up (no sorries eliminated this iter; +1 in TensorObjSubstrate via
  decomposition, +5 in the new CechHigherDirectImage scaffold).
- **Files touched by provers:** `Picard/TensorObjSubstrate.lean`, `Picard/TensorObjSubstrate/DualInverse.lean`,
  `Cohomology/CechHigherDirectImage.lean` (NEW). `Picard/LineBundleCoherence.lean` held (verified DONE, no edits).
- **Headline:** **A structural / scaffold iter with ZERO sorry eliminations.** All three prover lanes
  produced real, compiling code but closed nothing: D3′ decomposed (2→3), the dual lane built leg-A +
  resolved its instance wall (no close, 7 typed sub-sorries), and the engine `Rⁱf_*` Čech file was
  scaffolded fresh (5 sorry + 1 real def, builds green). Honest net: forward motion in structure, no
  frontier close.

## Targets

### 1. `pullbackTensorMap_restrict` (TensorObjSubstrate.lean, D3′) — PARTIAL (2→3 sorry)
- **What ran (compiles):** `simp only [pullbackTensorMap, tensorObjIsoOfIso]` unfolds BOTH sides into the
  four-fold composite `S1 ≫ a.map δ ≫ S3 ≫ S4`; `rw [Functor.map_comp ×3]` distributes the RHS
  `(pullback h).map (…)`; `simp only [Category.assoc]` right-associates → explicit 4-vs-10 factor identity.
- **Key finding (verified from the goal):** the four squares **interleave** — `S1_h` on the RHS acts on
  `tensorObj ((pullback f).obj M).val ((pullback f).obj N).val`, NOT on `PrPb_f (M⊗N)`. The paste cannot
  group the S1's directly; factors must slide past each other via `δ_natural` / NatTrans naturality (the
  D1′ merge of `a.map δ ≫ S3 ≫ S4` into one `a.map Ψ`).
- **Blocked on:** unbuilt Sq1 (`sheafificationCompPullback_comp`, below) + Sq4 (`pullbackValIso`
  composition coherence, still UNBUILT). Sq4 factors through Sq1 since
  `pullbackValIso = (sheafCompPb).symm ≪≫ pullback.mapIso counit` + a sheafification-counit coherence.

### 2. `sheafificationCompPullback_comp` (TensorObjSubstrate.lean, NEW Sq1 sub-lemma) — PARTIAL
- **What ran (compiles):** `apply (A_{h≫f}).homEquiv _ _ |>.injective` (transpose) →
  `rw [sheafificationCompPullback_eq_leftAdjointUniq]` (the project's `rfl` linchpin, L1598) →
  `erw [Adjunction.homEquiv_leftAdjointUniq_hom_app]` (collapses LHS to `B_{h≫f}.unit.app P`) →
  `rw [Adjunction.homEquiv_unit, Adjunction.comp_unit_app, Adjunction.comp_unit_app]` → concrete unit identity.
- **`erw` REQUIRED** for `homEquiv_leftAdjointUniq_hom_app`: composite left adjoint of `B.comp` is spelled
  `pullback φ' ⋙ sheafification`, not syntactically `F'.obj P`.
- **Dead end logged:** `Mathlib.leftAdjointUniq_trans_app` does NOT apply — it requires the three
  adjunctions to share the SAME right adjoint `G`; here the three `sheafCompPb` isos have different right
  adjoints. The coherence is the genuine pseudofunctor-tensorator interchange.
- **Residual:** transport the two `pullbackComp` factors across the adjunctions (sheaf `pullbackComp h f`
  via `conjugateEquiv_pullbackComp_inv`/`unit_conjugateEquiv` with `pushforwardComp = Iso.refl`; presheaf
  `pullbackComp φ'_f φ'_h` sheafified) → re-express R0/R1/R5/δ_pre as f/h-unit factors → collapse via
  `comp_unit_app` + `unit_naturality`. This is the δ-free twin of the proved `pullbackObjUnitToUnit_comp`
  (L910) mate calculus, ~60-100 LOC.

### 3. `sliceDualTransport` (DualInverse.lean, route-2) — PARTIAL (no decl-count change; 2→2)
- **Module-instance wall RESOLVED** (the iter-260 "instance-delicate" warning): the structure literal
  re-synthesizes `Module 𝒪_Y(V)` on the **`pushforward₀`-reduced** carrier and fails. FIX:
  `set β := Functor.whiskerRight {app := fun U => (Hom.appIso f U.unop).inv} (forget₂ …)` re-folds the goal;
  `letI lhsMod := inferInstance`; `letI rhsMod := InternalHom.internalHomObjModule (R := Y.presheaf) V.unop
  ((pushforward β).obj M.val) (𝟙_ _)` (NOT `inferInstance`); `refine LinearEquiv.toModuleIso (m₁ := lhsMod)
  (m₂ := rhsMod) ?_` — the `m₁`/`m₂` MUST be passed explicitly (else deferred metavars re-synth+fail).
- **toFun leg-A BUILT (compiles):** component at `W` is
  `(ModuleCat.restrictScalars (β.app (op W.unop.left)).hom).map (φ.app (op (Over.mk (f.opensFunctor.map W.unop.hom)))) ≫ ?codomainMap`.
  KEY: build **categorically via `.map`** — raw `ModuleCat.ofHom {toFun:=…}` reduces the carrier and loses
  the `restrictScalars`/`pushforward₀` module instance.
- **codomainMap BLOCKED** (`inv (ε (restrictScalars β_W))`) on two named frictions:
  - **(a) CommRing-instance loss.** `restrictScalars_isIso_ε_of_bijective` (PresheafInternalHom L212,
    top-level, no namespace) needs `[CommRing R] [CommRing S]`, but the section rings appear as
    `forget₂ CommRingCat RingCat`-images `↑(Y.ringCatSheaf.obj.obj (op W'))` whose `CommRing` is not
    synthesized at the `RingCat` spelling.
  - **(b) `𝟙_`-vs-`restr`-section defeq.** `ε`'s type carries `𝟙_ (ModuleCat …)` but the goal carries the
    defeq-but-not-syntactic `(restr V 𝟙_Y).obj W` unit-section forms; `exact inv (ε …)` won't unify.
- **7 typed sorries** remain inside (codomainMap, naturality, invFun, map_add'/map_smul'/left_inv/right_inv).
  Not a pivot to the stalk Plan-B — route-2 is being executed as sanctioned.

### 4. `CechHigherDirectImage.lean` (engine `Rⁱf_*` Čech lane) — SCAFFOLDED (NEW file, builds green)
- Honest signatures for six blueprint `\lean{...}` decls; 5 typed `sorry` + 1 REAL def
  (`cechHigherDirectImage := (CechComplex f 𝒰 F).homology i`). `lake build` → success.
- **Mathlib API note:** `Scheme.OpenCover` is now `(Scheme.precoverage IsOpenImmersion).ZeroHypercover X`
  — index `𝒰.I₀`, scheme `𝒰.X j`, map `𝒰.f j`, finiteness `[Finite 𝒰.I₀]` (the old `𝒰.J`/`𝒰.obj`/`𝒰.map`
  are GONE). `Scheme.Modules` is `Abelian` → `CochainComplex S.Modules ℕ` has `.homology i : S.Modules`.
- **NOT imported** in `AlgebraicJacobian.lean` (matches the `HigherDirectImage` convention — also absent).
  Prover flagged: add the import if the file should join the top-level build graph.

### 5. `LineBundleCoherence.lean` (A.2.c engine) — DONE (held, verified)
- All three main theorems (`isFinitePresentation`/`isFiniteType`/`chart_free_rank_one`) verify
  `{propext, Classical.choice, Quot.sound}` (kernel-only). 4 `sorry` grep matches are all docstring text.
  No edits.

## Key findings / patterns
- **D3′ four-square paste interleaves** — cannot be a direct square-grouping; needs `δ_natural`-style
  factor-sliding (the D1′ merge technique). Sq1 + Sq4 must land first.
- **`set β` + explicit `(m₁ :=)(m₂ :=)`** is the recipe to enter a `LinearEquiv.toModuleIso` whose carriers
  reduce away the needed `Module` instance; build component maps via categorical `.map`, never `ModuleCat.ofHom`.
- **Mathlib `OpenCover` migrated to `ZeroHypercover`** field names — recorded for the engine lane.

## Subagent outcomes (full reports in logs/iter-261/)
- **lean-auditor (aud261):** 0 must-fix, **3 major** (all stale status-comment sorry-counts:
  `TensorObjSubstrate.lean:43-44` says "ONE tracked typed-sorry residual" but there are now THREE;
  `:132` module-layout note misses the two D3′ sorries; `DualInverse.lean:24-35` header labels
  `sliceDualTransport` "HELD (iter-258)" — stale, now PARTIAL iter-261), 5 minor. These are `.lean`
  edits (prover-owned) → folded into recommendations for the re-opening prover. Report:
  `task_results/lean-auditor-aud261.md`.
- **lean-vs-blueprint-checker (lvb-tos261, lvb-di261, lvb-cech261):** see recommendations.md.

## Blueprint markers updated (manual)
- None this iter (see review.md for rationale). `sync_leanok` (iter=261, sha `915d2863`) added 6 markers on
  `Cohomology_CechHigherDirectImage.tex` statement blocks — correct (the six scaffold decls now exist).

## Blueprint doctor
- Clean — no orphan chapters, no broken `\ref`/`\uses`, no new axioms.
