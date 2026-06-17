# Session 57 (iter-057) — review summary

## Metadata
- **Iteration / session:** iter-057 / session_57. Model: claude-opus-4-8.
- **Inline sorry:** 10 → **10** (no regression, no closures — foundation-building iter; the +16
  new declarations sit *under* the assembly-site sorries, not at them). **None forced/papered**
  — every residual is an honest hole (auditor + all 3 lvb checkers confirmed).
- **Lanes planned 3, ran 3** — all PARTIAL-with-major-progress. **+16 axiom-clean declarations**
  (6 CechAcyclic + 6 CechSectionIdentification + 4 OpenImmersionPushforward).
- **Build:** GREEN. Re-verified first-hand: a combined `import` of all 3 files + `#print axioms` on
  5 keystone decls (`sectionCech_homology_exact_of_affineOpen`, `dDiff_exact_of_affineCover`,
  `modulesIsoSpecExtTransport`, `coverArrowOverSigmaIso`, `widePullback_openImm_inter`) all =
  `{propext, Classical.choice, Quot.sound}`.
- **dag-query:** gaps = 0 (no ∞ holes); **unmatched = 13** (12 new lean_aux this iter + pre-existing
  dead `CechAcyclic.affine`). `sync_leanok` ran iter-057 (sha `35ef130`, +17/−0).
- **blueprint-doctor:** 1 finding (`\bigsqcap` undefined macro) — **FIXED this review** (→ `\bigcap`,
  matching the rest of the chapter).

## Headline — the Need #2 `htilde` seed CLOSED in one iteration (CechAcyclic Lane)
The decisive win: the general-affine-open Čech vanishing seed
(`lem:affine_cech_vanishing_general_seed`, the lone residual that gated Need #2's open-immersion
acyclicity since iter-056) is **fully built, axiom-clean, in one iter** — 6 declarations:
- `isLocalizedModule_baseChange_away` — the genuinely-new ingredient: `M → M⊗_R S → (M⊗_R S)_{s̄σ}`
  is `IsLocalizedModule (powers a)` over `R` via base-change transitivity
  (`IsBaseChange.comp (TensorProduct.isBaseChange R M S) hg` + `isLocalizedModule_iff_isBaseChange`).
  The memory-flagged `IsScalarTower`/semiring diamond did **not** materialise (OreLocalization
  machinery resolves canonically).
- `SectionCechModule.dDiff_exact_of_affineCover` — near-verbatim mirror of the `D(f)` template
  `dDiff_exact_of_localizationAway`, with `Rf ⇝ S = Γ(V)` abstract and `Mf ⇝ M⊗_R S`.
- `sectionCech_homology_exact_of_affineOpen` — the consumer-facing target: takes `IsAffineOpen (⨆ᵢ D(sᵢ))`
  and discharges the change-of-base data `(S=Γ(V), hspan, hloc)` from geometry.

Its conclusion shape is identical to the DONE `D(f)` sibling `sectionCech_homology_exact_of_localizationAway`,
so it discharges the `htilde` hypothesis of `affine_cech_vanishing_qcoh_general_of_tildeVanishing`
verbatim. **Need #2 is now end-to-end modulo a ~10-LOC consumer wiring** in AffineSerreVanishing.lean
(`private affine_tildeVanishing_general`, mirror `affine_tildeVanishing` swapping
`_of_localizationAway → _of_affineOpen`).

### The instance-trap that cost ~half the CechAcyclic session
`Algebra Γ(V) Γ(D a)` is **NOT a synthesizable instance** in current Mathlib — it depends on the
inclusion morphism `D a ⟶ V`. `isLocalization_of_eq_basicOpen` constructs it ad-hoc as
`((Spec R).presheaf.map (homOfLE hDaV).op).hom.toAlgebra`; the prover had to `letI` exactly that,
plus `haveI : IsScalarTower R Γ(V) Γ(D a) := IsScalarTower.of_algebraMap_eq (fun _ => rfl)`.
**Critical tooling warning recorded by the prover:** `lean_run_code` / `lean_multi_attempt` used a
STALE `.olean` of CechAcyclic and gave FALSE "success" on the failing instances — only
`lake env lean` / `lake build` / `lean_diagnostic_messages` were reliable for instance-sensitive work
in this file.

## Lane — Need #1 Ext transport core built (OpenImmersionPushforward)
`modulesIsoSpecExtTransport` (Ext transport along the whole-scheme spectrum equivalence) is built
axiom-clean, 4 declarations. The decisive find (Mathlib source scan, not search) was
`Functor.mapExt_bijective_of_preservesInjectiveObjects` (`MapBijective.lean:65`): a fully-faithful,
exact, injective-preserving functor over a category with enough injectives induces a **bijective**
`mapExtAddHom`. This **replaces** the absent `Ext.mapExactFunctor` functor-composition route (which
does not exist in Mathlib and would have been a deep gap). Chain:
`pushforwardEquivOfIso (Equivalence.mk)` → equivalence-functor instances auto (`Full`/`Faithful`/
`PreservesFiniteLimits/Colimits`/`PreservesInjectiveObjects`; only `.functor.Additive` needs an
explicit `inferInstanceAs`) → `pushforwardExtAddEquiv := AddEquiv.ofBijective (… mapExtAddHom …)` →
instantiate at `Scheme.isoSpec`. Needs `attribute [local instance] hasExtModules` + `[EnoughInjectives
U.Modules]` (the latter NOT auto-derived from `HasInjectiveResolutions`; ~6-LOC connector at consumer).

**Remaining hard gap (multi-iter, NOT near-rfl):** `jShriekOU` naturality under a scheme iso
`(pushforwardEquivOfIso φ).functor.obj (jShriekOU V) ≅ jShriekOU (φ.hom ''ᵁ V)` — commuting pushforward
with the free/sheafification adjunction + yoneda transport across the homeomorphism `φ`. The two
residual sorries (`_acyclic` line 373, `_comp` line 439) are the assembly site, gated on this + Need#2.

## Lane — Stub-1 geometric backbone advanced (CechSectionIdentification)
6 axiom-clean declarations: `mem_iInf_opens_of_finite` (private), `widePullback_openImm_inter`
(wide/iterated analogue of binary `isPullback_opens_inf`, which Mathlib has only binary),
`cechBackbone_obj_widePullback` (definitional, `Iso.refl`), and the `coverArrowOverSigmaIso`
coproduct-in-`Over X` leaf (+ `coverArrowOverCofan`/`coverArrowOverIsColimit`). The hard
`coproduct_distrib_fibrePower` (product distributes over coproduct in `Over X`, a 120–200 LOC
`FinitaryPreExtensive` induction) was correctly NOT stubbed — deferred by budget, with a precise
4-step residual decomposition recorded. **`isColimitOfReflects (Over.forget X) …` dead-end avoided:**
`mapCocone t` is not *syntactically* the standard sigma cofan, so `mkCofanColimit` is the clean route.

## Subagent findings (full reports linked; act in recommendations.md)
- **lean-auditor `iter057`** (`task_results/lean-auditor-iter057.md`): 1 must-fix-block + 1 major + 3 minor.
  CechAcyclic clean; OpenImm two honest sorries; **CSI two must-fix** = lines 424/481 carry `sorry` on
  **provably-false** non-augmented signatures (`D ≅ D'`, `Homotopy (𝟙 D') 0`), and the `⚠ PROVER FINDING`
  block (lines 333–366) reads as an excuse-comment. Major: `isZero_of_faithful_preservesZeroMorphisms`
  is **duplicated** between OpenImmersionPushforward and CechAugmentedResolution.
- **lvb `openimm`** (`…-openimm.md`): Lean clean (0 red flags); **blueprint 3 major adequacy failures** —
  `lem:modules_isoSpec_ext_transport` proof body still describes the absent `Ext.mapExactFunctor`
  composition; falsely claims the transport establishes jShriekOU naturality (it's an open residual);
  jShriekOU-naturality has no standalone block.
- **lvb `cechacyclic`** (`…-cechacyclic.md`): 6 decls axiom-clean, correct sigs; **major** route-B1
  coverage asymmetry (only 1 `\lean`-pinned lemma vs route-B's 3+); 3 public decls absent from blueprint;
  `\uses` of the seed block wrongly lists `lem:isoSpec_scheme_mathlib`; blueprint omits the
  `Algebra Γ(V) Γ(D a)` instance trap.
- **lvb `csi`** (`…-csi.md`): 2 must-fix (the 424/481 stale non-augmented signatures — blueprint was
  corrected to `D'_aug`, the Lean was NOT re-signed) + major coverage gap (`coverArrowOverSigmaIso` +
  helpers no block).

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`: `\bigsqcap` → `\bigcap` (×2, lines ~7653–7654) — undefined
  macro flagged by blueprint-doctor; the rest of the chapter uses `\bigcap`.
- `Cohomology_CechHigherDirectImage.tex`, `lem:cechBackbone_obj_widePullback`: stripped stale
  `% NOTE: build target … does not exist yet` (decl now exists, axiom-clean).
- `Cohomology_CechHigherDirectImage.tex`, `lem:widePullback_openImm_inter`: stripped stale
  `% NOTE: build target …` (decl now exists, axiom-clean).
- `Cohomology_CechHigherDirectImage.tex`, `lem:modules_isoSpec_ext_transport`: corrected
  `\lean{…modulesIsoSpecExtTransport_TODO}` → `\lean{…modulesIsoSpecExtTransport}`; replaced the
  stale "does not exist yet / via Ext.mapExactFunctor" NOTE with an accurate one naming
  `mapExt_bijective_of_preservesInjectiveObjects` + the `[EnoughInjectives]` requirement.

## Notes (LOW)
- Several `set_option maxHeartbeats 1600000`/`synthInstance.maxHeartbeats 800000` raises in CechAcyclic
  — auditor confirmed all carry legitimate explanatory comments for heavy base-change instance search;
  none mask broken proofs.
