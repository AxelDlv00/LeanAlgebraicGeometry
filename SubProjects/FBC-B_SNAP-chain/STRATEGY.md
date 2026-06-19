# Strategy

## Goal

Close the `sorry`-bearing nodes of the two **Čech-independent (i=0)** legs split out of the parent
*Quot-Foundations* `thm:fga_pic_representability` cone, then merge back (names/labels are the parent's):

- **FBC-B** — flat base change of the degree-0 pushforward: the i=0 map `g^* f_* F ⟶ f'_* g'^* F` is an
  isomorphism. Seed decls `affineBaseChange_pushforward_iso` + `flatBaseChange_pushforward_isIso`
  (`thm:flat_base_change_pushforward`), reached via the CONCRETE-tilde equalizer chain.
- **SNAP** — the section graded ring `Γ_*(X,L) = ⊕_{n≥0} Γ(X,L^{⊗n})` as a graded commutative semiring
  (`lem:sectionGradedRing_gcommSemiring`) + its graded module (`lem:sectionGradedModule_gmodule`).

End-state: zero project `sorry` in these two cones, zero axioms (kernel-only).

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-B — global H⁰ iso (concrete-tilde equalizer chain) | ACTIVE | 3–5 (over budget: 9 elapsed since iter-003) | ~180–350 | `TensorProduct.piRight`, `tensorEqLocusEquiv` (present); `Mathlib.CategoryTheory.Adjunction.Mates` (3 mate-composition lemmas + `TwoSquare` API, verified iter-009); Stacks 01XJ (unconfirmed) | (a) per-chart iso done sorry-free; (b) crux DECOMPOSED into 4 seams (seam1 brick PROVED). 3 mate lemmas EXIST (iter-009 analogist; `TwoSquare`-valued `mateEquiv`, recover via `.natTrans`). Crux gated on foundation `gammaPushforwardNatIso_comp`: iter-009 found its "pointwise-rfl" recipe FALSE (real = 3-fold global-sections coherence) AND monolithic simp overflows the kernel. iter-010 DECOMPOSED it kernel-light into 2 sub-lemmas (`globalSectionsIso_hom_comp3_specMap_appTop` + `gammaPushforwardIso_comp`, assembled via `NatTrans.ext`). iter-011 (pc011 CHURNING): chapter must-fix-patched (stale "pointwise-rfl" prose + missing `\uses`) + GATE CLEARED → FBC `prove` prover FIRING (scaffold+prove the 2 sub-lemmas, close foundation, attempt crux). Chain decls gain separated/finite/qcoh hyps on fill. 01XJ folded in; see Open Q. iter-011 PARTIAL: foundation own-body CLOSED, residual = 1 named cast `Γ(cast) x=x` gated on 2 named rw-only exposure lemmas (kernel-light; defeq route = verified kernel bomb). iter-012 (pc012 CHURNING, focused lane = genuine corrective): build the 2 exposure lemmas + close `gammaPushforwardIso_comp` as a unit. If unclosed → Mathlib-idiom consult on `ConcreteCategory.hom (eqToHom _) x=x`. |
| SNAP — `Γ_*(X,L)` graded comm ring assembly | ACTIVE | 3–5 (over budget: 7 elapsed since iter-005) | ~150–300 | **`CategoryTheory.Localization.Monoidal`** (`LocalizedMonoidal`, `μ_natural_left/right`, `associator_hom_app`), `DirectSum.GCommSemiring`/`Gmodule` | Foundation + braiding bridge + 3 section coherences DONE. iter-007 "associator bridge = clone of braiding bridge" premise PROVEN FALSE (it is a 5-segment composite vs a μ-formula). iter-008 effort-breaker DECOMPOSED `tensorObjAssoc_eq_localizedAssociator` into 4 `\lean`-stubbed seams (keystone via `μ_natural_left` + left-variant + braiding-collapse + seg2-defeq). bp009 PASS. iter-009 PROVED all 4 seams axiom-clean + materialized the assembly `tensorObjAssoc_eq_localizedAssociator` (one `associator_naturality` general→L'-object reduction from done; template = proven `tensorBraiding_eq_localizedBraiding`). iter-010 `prove` lane PARTIAL ("one step from done" disproved 2 iters; μ-pair won't cancel = 3 rfl-defeq folds). iter-011 (pc011 CHURNING): mathlib-analogist consult (`analogies/snap-mu-nesting.md` — no zero-restate coherence; isolate + `show`-pin μ + `Iso.hom_inv_id_assoc`; structural alt = `associator_hom_app`) → effort-break into a 4-lemma chain (2 canonical-μ keystones + `hK_lhs`/`hK_rhs`; assembly = `hK_lhs.trans hK_rhs.symm`) + GATE CLEARED → SNAP `fine-grained` prover FIRING; 5 coherences cascade on close. iter-011 PARTIAL: 2 canonical-μ keystones CLOSED, object-fold blocker CLEARED; residual gated on deriving the well-typed Lean common form `K` (not a blueprint gap) + the 2 isolated halves. iter-012 (pc012 CHURNING, focused lane = genuine corrective): VERIFY K typechecks via `associator_hom_app` FIRST, then `hK_lhs`/`hK_rhs`, assembly = `hK_lhs.trans hK_rhs.symm`. If unclosed → Mathlib-idiom consult on `Localization.Monoidal` entry point. |

## Completed

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| FBC RegroupHelper | 011 · 4 | ~120 | RegroupHelper.lean | `regroupEquiv` `(A⊗_R R')⊗_A M ≅ R'⊗_R M` axiom-clean | `eT` identity-bridge + `TensorProduct.induction_on` to beat transparent-instance diamonds | element `map_smul'` zero-branch needs `erw [TensorProduct.zero_tmul]` |
| SNAP coequalizer rows | 060 · 3 | ~400 | SectionGradedRing.lean | `relTensorActL/R/Proj` objectwise coequalizer nat-transforms; `RelativeTensorCoequalizer` 22-decl API | carrier gap fixed by `objRestrict`; `relTensorProj.naturality` = bare-ℤ `TensorProduct.ext'` then transport to `AddCommGrpCat` | the `forget₂ CommRingCat→RingCat` carrier "blocker" was illusory — real obstacle was additivity |
| SNAP crux chain + graded bricks | 001 · ~1 | ~600 | SectionGradedRing.lean | `ztensor_whisker_localIso`, `isIso_sheafification_whiskerRight_unit`, `tensorObjAssoc`, `tensorPowAdd`; graded bricks (`sectionsCast`, `GMul`/`GOne`, `instGMonoid/Semiring/CommSemiring` scaffold) | sheafification-functoriality of presheaf monoidal isos; `sectionsCast`+`gradedMonoid_eq_of_cast` for index-reindex | stalkwise / "presheaf+Γ-at-end" / full `MonoidalCategory(SheafOfModules)` routes DEAD; carrier `AddCommGrpCat` not `AddCommGrp` |
| SNAP left-unit coherence | 002 · 1 | ~120 | SectionGradedRing.lean | `sectionsMul_one_mul` axiom-clean; reusable `unitor_sectionsMul` adjunction-transpose core | `adj.homEquiv` `.apply_eq_iff_eq_symm_apply` + `homEquiv_counit` term-mode; `show`/`change` (default transparency) mandatory to split `Γ(f≫g)` across the `X.Modules` diamond | positional `rw [val_app_top_comp]`/`comp_apply`/`hom_comp` fail (reducible-transparency mismatch) |
| FBC module core + concrete pivot | 002 · 2 | ~500 | FlatBaseChangeGlobal.lean | `gammaTopEquivEqLocus`, `baseChangeGammaEquiv`, finite-cover equalizer; pivot off mate → concrete-tilde; bridge forward dir | `H⁰(X,F)=Γ(X,F)` = finite equalizer `∏Γ(Uᵢ)⇉∏Γ(Uᵢⱼ)`; flat `−⊗B` preserves it (`tensorEqLocusEquiv`) | mate keystone `_legs_conj`/`_gstar_transpose` + `_sections_direct` (illusory, collapses onto mate) abandoned |

## Routes

Single route per leg; the two legs are independent and merge back upstream.

**FBC route — concrete-tilde equalizer chain (Čech-cohomology-free).** Both named seed legs are reached
WITHOUT the adjoint-mate keystone. `H⁰(X,F)=Γ(X,F)` is the finite equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)`
over a finite affine cover of a separated qc scheme, and flat `−⊗B` preserves it. Module core DONE
0-sorry (`FlatBaseChangeGlobal.lean`). The frontier `baseChange_sheafConditionFork_tensorIso`
(`lem:base_changed_equalizer_diagram`) was decomposed iter-003 into (a) per-chart iso
`baseChange_chart_tensorIso` (01I9 + affine cancellation), (b) the crux
`pullback_spec_tilde_iso_restriction_naturality` (restriction-compatibility of the concrete affine
tilde-pullback iso along an open immersion of affines — the explicit localization functoriality, not
the mate), (c) `TensorProduct.piRight` (Mathlib). (a)'s affine cancellation `(B⊗_A R)⊗_R M ≅ B⊗_A M`
is Mathlib's `TensorProduct.AlgebraTensorModule.cancelBaseChange` (`Mathlib.LinearAlgebra.TensorProduct.Tower`,
verified loogle iter-003); the project's proved `regroupEquiv` (RegroupHelper.lean) is an equivalent
fallback. Assembly then climbs separated → Mayer–Vietoris → bridge
`flatBaseChange_isIso_iff_gammaTensorComparison` → goal.

*Mate route abandoned, but BOTH seed decls are deliverables.* `flatBaseChange_pushforward_isIso` AND its
affine specialization `affineBaseChange_pushforward_iso` are named goal seeds that must end zero-sorry;
both receive CONCRETE-chain bodies (the affine seed from per-chart (a)+`regroupEquiv`; the global seed
via the bridge). What is dead is the sheaf-level adjoint-MATE PROOF route — the deletable apparatus is
`base_change_mate_{domain,codomain}_read`/`_gstar_transpose`/`_section_identity`/`_generator_trace` +
the `pushforward_base_change_mate_*` helpers (KEEP `base_change_mate_regroupEquiv`, used by (a), and
`base_change_map_affine_local`). The apparatus is 100% COMPILE-DEAD (verified iter-005: nothing outside
the chain calls it; the seeds are bare `sorry`), so the old "would break a proved seed" gate premise is
FALSE. Excision is deferred only for HYGIENE sequencing — it must run in a dedicated cleanup iter (not
the same iter as the FBC crux prover, to avoid file-instability), and must sync the blueprint `\uses`
web the same iter. The seeds keep clean `sorry` stubs until the concrete chain fills them.

**SNAP route — sheaf tensor powers ⟹ graded ring, coherence by monoidal localization.** `Γ_*(X,L)` is
the direct sum of section groups of `L^{⊗n}`, with multiplication from the lax-monoidal section pairing
`sectionsMul` plus the `tensorPowAdd` index-addition isos; the graded structure rides
`DirectSum.GCommSemiring`. The monoidal bricks (`sectionsMul`, `tensorObj{Assoc,UnitIso,RightUnitor}`,
`tensorBraiding`, `tensorPowAdd`) and 3 of the section coherences are DONE. The remaining 5 sorries all
reduce to Mac Lane coherence transfer through the comparison isos — a multi-hundred-LOC hand-proof now
AVOIDED: Mathlib's `CategoryTheory.Localization.Monoidal` builds a full symmetric `MonoidalCategory`
(pentagon/triangle/hexagon) on the type synonym `LocalizedMonoidal L W ε` of the localized category,
with `L = PresheafOfModules.sheafification`, `[L.IsLocalization W]` already a Mathlib instance,
`C = PresheafOfModules` symmetric monoidal, and the only new obligation `W.IsMonoidal` discharged by the
proved `ztensor_whisker_localIso`. The remaining work is real but bounded: instantiate the synonym,
then BRIDGE each hand-built coherence morphism to the synonym's structure morphism (glue option B,
blueprinted) — or rewire the hand-built defs onto the synonym's `⊗` (glue option A, a refactor that
makes the bridges definitional); the 5 coherences then follow from the Mathlib laws. The synonym sits
on a type synonym, not on `X.Modules` directly, which is what dodges the dead full-instance diamond.

## Open strategic questions

- **FBC chain signatures.** The scaffolded chain decls (`baseChange_sheafConditionFork_tensorIso`,
  `baseChangeEqLocusToPullbackGamma`, `baseChangeGammaPullbackEquiv`) currently omit
  `[IsSeparated X]`/finiteness/`[F.IsQuasicoherent]`. These must be added (not protected — re-sign
  freely) when their sorries fill, else the per-chart + finite-product steps are unlicensed.
- **FBC qcqs-pushforward-QC (Stacks 01XJ) — UNCONFIRMED, scheduled.** The sheaf-level seed
  `flatBaseChange_pushforward_isIso` and the bridge reverse need `g^*(f_*F)`/`f'_*F'` quasi-coherent over
  the affine base + "iso on global sections ⟹ iso of QC sheaves over an affine". Probed iter-003: loogle
  no hit, leansearch down — not confirmed in Mathlib. PLAN: re-verify before the bridge-reverse lane; if
  absent, build project-side via `[prover-mode: mathlib-build]` (est. ~1–2 iters / ~100–200 LOC). Off
  this iter's critical path (this iter proves the affine (a)/(b)).
- **SNAP `W.IsMonoidal` — RESOLVED (iter-004).** `W_isMonoidal` landed axiom-clean: `whiskerRight` =
  `ztensor_whisker_localIso`, `whiskerLeft` by braiding conjugation (symmetric `C`), multiplicativity
  + RespectsIso from Mathlib on `inverseImage`. `localizedMonoidalUnitIso` + `modulesLocalizedMonoidal`
  also landed → symmetric `MonoidalCategory` for free.
- **SNAP glue choice — RESOLVED → Option B (iter-005).** Option A (redefine `tensorObj := ⊗_loc`)
  REJECTED: `tensorObj` feeds `tensorPow`/`moduleTensorPow`/`sectionsMul` via `(F♭⊗_p G♭)(⊤)` defeq —
  redefinition has a large defeq blast radius. Option B: keep hand-built defs, bridge via the
  object-identification iso `tensorObjLocalizedIso = μ⁻¹;counit` (the localized `⊗_loc` is NOT defeq to
  `tensorObj`, so the 4 bridges are object-iso-CONJUGATED commuting squares, not bare equalities).

## Mathlib gaps & new material

Gaps to fill:
- FBC: `pullback_spec_tilde_iso_restriction_naturality` — concrete localization functoriality of the
  tilde-pullback dictionary; project-built axiom-clean (no upstream PR needed). Affine cancellation for
  (a) = Mathlib `TensorProduct.AlgebraTensorModule.cancelBaseChange` (verified, `…TensorProduct.Tower`)
  or project `regroupEquiv` (DONE). `TensorProduct.piRight` present (loogle); `tensorEqLocusEquiv`
  present. qcqs-pushforward-QC (01XJ) UNCONFIRMED — see Open Q.
- SNAP coherence: use Mathlib `CategoryTheory.Localization.Monoidal` (`LocalizedMonoidal L W ε`) —
  full symmetric monoidal + pentagon/triangle/hexagon for free. New project material: the
  `W.IsMonoidal` instance (from `ztensor_whisker_localIso` + braiding-conjugate), the unit iso `ε`, and
  the synonym instantiation/bridges. `β_{𝟙𝟙}=𝟙` = `braiding_tensorUnit_left`+`unitors_equal`. The
  CLOSED bridge set (iter-007 analogist `analogies/snap-bridge-api.md`): structural
  `tensorObjAssoc_eq_localizedAssociator` (`associator_hom_app`), `tensorObjUnitor_eq_localized`
  (`leftUnitor_hom_app`), `tensorObjRightUnitor_eq_localized` (FREE: braiding∘unitor), + whiskering
  `tensorObjWhiskerRight_eq_loc` (`μ_natural_left`), `tensorObjWhiskerLeft_eq_loc` (`μ_natural_right`).
  Then iso-coherences close by `rw bridges; Iso.ext; telescope; exact pentagon/triangle/hexagon`.
  KEY: iso-level obstacle is the missing whiskering bridges (the `i`'s telescope formally), NOT a
  "comparison-acts-trivially" step — that conflation drove the prior churn.

New project material:
- FBC concrete chain (per-chart iso + restriction naturality + finite-product commutation + assembly).
- SNAP tensor-power coherences + the `Γ_*(X,L)` graded (co)semiring/module instances.
