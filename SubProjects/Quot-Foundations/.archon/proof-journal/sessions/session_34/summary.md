# Session 34 — Review of iter-034 (Quot-Foundations)

## Metadata
- **Iter / session:** iter-034 / session_34. Model: claude-opus-4-8 (provers).
- **Lanes dispatched:** 4 parallel, import-independent (FBC-A, FBC-B, QUOT-P1, GR-sep).
- **Active `sorry` (per file):** FBC 4→4, QUOT 4→4 (protected stubs), GR 0→0, FBCGlobal 0→0,
  Flattening 6 (untouched, gated). **Net active sorry: unchanged.**
- **New axiom-clean declarations this iter: ~37** across 4 files
  (`{propext, Classical.choice, Quot.sound}`, verified by provers + lean-auditor).
- **Build:** GREEN. All 4 touched modules `lake build` exit 0 (pre-existing sorry + style warnings
  only). blueprint-doctor: **0 findings**. `sync_leanok` (iter 34, sha `b41177a`): **+19 `\leanok`,
  0 removed**. leandag `gaps=0`, `unmatched=33` (coverage debt — see recommendations).

**Three-keystones-landed iter.** Net 0 active sorry, but three of the four lanes hit their pinned
keystone (`Grassmannian.isSeparated`, `isIso_fromTildeΓ_restrict_basicOpen`, the FBC-B
`gammaTopEquivEqLocus`/`baseChangeGammaEquiv` payoff). Only FBC-A's deep `_legs` crux remains —
its conjugate-route foundation (conj-0) landed but the keystone did not close → **tripwire fires**.

## Targets

### GR-sep — `Grassmannian.isSeparated` (`lem:gr_separated`): SOLVED, axiom-clean
The keystone of the separatedness lane. Route (b), refined: because `scheme d r : Scheme.{0}`,
`Spec ℤ` is **genuinely terminal** (`specZIsTerminal`), so `toSpecZ := specZIsTerminal.from` and the
per-chart `ι_toSpecZ` are `IsTerminal.hom_ext` — no `glueMorphisms`, no terminal-vs-`Spec ℤ`
reconciliation. The morphism-form `isSeparatedToSpecZ` is a direct port of
`AlgebraicGeometry.Proj.isSeparated` (`IsZariskiLocalAtTarget.of_openCover` →
`pullbackDiagonalMapIdIso` → `IsClosedImmersion.spec_of_surjective` on
`diagonalRingMap_surjective`). `isSeparated` = `Scheme.isSeparated_iff` + composite-with-affine.
7 axiom-clean decls added (`toSpecZ`, `ι_toSpecZ`, `pullbackιIso_inv_fst/snd`,
`chartTransition_comp_chartIncl`, `isSeparatedToSpecZ`, `isSeparated`).
- **Lean-specific gotchas (now in Knowledge Base):** `pullback.map_fst`/`map_snd` do NOT exist in
  this Mathlib — the congrHom leg is collapsed by hand with `pullback.lift_fst`/`lift_snd` +
  `Category.comp_id` BEFORE `erw [pullbackDiagonalMapIdIso_inv_snd_fst]`. Leg lemmas need `erw` (the
  goal carries the defeq `openCover.f i` vs the stated `theGlueData.ι i`). `convert!` does NOT exist
  (use `convert ... using 1`). `← Spec.map_comp` as a bare `rw` fails on the Scheme-cat instance
  diamond over heavy localisation objects — route through `show`-rewrite then
  `exact (Spec.map_comp _ _).symm`. `maxHeartbeats 3200000` + `backward.isDefEq.respectTransparency false`.

### QUOT-P1 — `isIso_fromTildeΓ_restrict_basicOpen` (`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`): SOLVED, axiom-clean
The pinned gap1 P1 keystone. Planner's 5-step affine descent (Z-route): a *global* presentation of
`N = (q.X i)^* M` on the genuine scheme `Z`, sliced to `N.over W` by a SIMPLE single
`Presentation.map (pushforward 𝟙)` (no iterated `bind` slice, because `PN` is already global on `Z`),
geometrized via `overRestrictPresentation`, transported across `IsAffineOpen.isoSpec`
(`W` = preimage of `D(r)`, affine), closed by `isIso_fromTildeΓ_of_presentation`. 7 axiom-clean decls;
the general form `isIso_fromTildeΓ_presentationPullback` (per affine open of a cover member) is
strictly more general and is the form gap1-D should consume.
- **Non-obvious facts:** `pullbackSchemeIsoUnitIso` must be STATED with
  `SheafOfModules.pullback (φ.inv.toRingCatSheafHom)`, NOT `Scheme.Modules.pullback φ.inv` (defeq, but
  the latter's bundled `IsContinuous`/`IsRightAdjoint` instances make `asIso`'s `IsIso` synthesis see
  a syntactically-different term and FAIL). `Final` of `Opens.map φ.inv.base` must be a `haveI` built
  from `opensMapEquivOfIso` (resolution cannot invert `φ.inv.base`). `Presentation.map` along
  `Scheme.Modules.pullback f` needs `(pullbackPushforwardAdjunction f).leftAdjoint_preservesColimits`
  explicitly. The α-factorization route (`IsOpenImmersion.lift` + `pullbackComp`) hits the same
  `Functor.Final (Opens.map j.base)` open-immersion wall flagged do-not-retry; the iso-only `Final`
  sidesteps it.

### FBC-B — `gammaTopEquivEqLocus` + `baseChangeGammaEquiv` (FlatBaseChangeGlobal.lean): SOLVED, axiom-clean
The ModuleCat-over-A `eqLocus` sub-lane + payoff, advancing **independently** of FBC-A (the
strategy-critic's parallelism corrective). 13-15 axiom-clean decls. `gammaTopEquivEqLocus`:
`Γ(M,⊤) ≃ₗ[A] eqLocus(leftRes, rightRes)` for any cover with `iSup U = ⊤`. `baseChangeGammaEquiv`
(beyond recipe scope): for flat `B`, `B ⊗_A Γ(M,⊤) ≃ₗ[B] eqLocus(lTensor leftRes, lTensor rightRes)`
— flat base change commutes with the H⁰ equalizer — via `gammaTopEquivEqLocus ∘ tensorEqLocusEquiv`.
- **Key design (Knowledge Base):** bijectivity via ELEMENT-level sheaf axioms
  (`TopCat.Sheaf.eq_of_locally_eq'` injectivity, `existsUnique_gluing'` surjectivity on
  `⟨M.presheaf, M.isSheaf⟩`), NOT the categorical product-matching bridge the recipe feared — this
  sidesteps matching `∏` in `Ab` with `Π`-types entirely. Base ring `A := X.presheaf.obj (op ⊤)`
  (CommRingCat, so `CommRing`/`Algebra` resolve); `M.val`-side rings carry only `Ring` but carriers
  are **defeq** through `restrictScalars` (load-bearing). `(M.val.map f).hom x = M.presheaf.map f x`
  by `rfl`. `restrictScalarsComp'App` with explicit `gf := rhoU V` lands directly in `gammaModA`
  (no `eqToHom`). `tensorEqLocusEquiv` confirmed real in `Mathlib.RingTheory.Flat.Equalizer`.
- **Gating:** the FBC-B chain assembly (`base_changed_equalizer_diagram`,
  `flat_base_change_separated`, `…_mayer_vietoris`) is genuinely gated on FBC-A's affine
  `affineBaseChange_pushforward_iso` — the base-changed-sheaf `M'` identification re-enters there.

### FBC-A — `base_change_mate_fstar_reindex_legs` (`_legs` crux): PARTIAL (conj-0 landed, keystone did not close)
The conjugate-side re-encoding's **Step-(i) foundation** landed: two axiom-clean lemmas
`pullbackComp_inv_eq_leftAdjointCompIso_inv` and `pullbackComp_eq_leftAdjointCompIso`, identifying
the project pseudofunctor coherence `pullbackComp` with the abstract `leftAdjointCompIso` of
`Mathlib.CategoryTheory.Adjunction.CompositionIso`. Proof: both invs have the same image
`(pushforwardComp f g).hom` under `conjugateEquiv`; `conjugateEquiv.injective` + `Iso.inv_eq_inv`.
Confirmed the pinned Mathlib has the full `CompositionIso` calculus.
- **What did NOT close:** conj-1 (re-cut `codomain_read_legs` proof-free from `leftAdjointCompIso`)
  was **deferred** — the existing read is consumed *definitionally* by the concrete
  `base_change_mate_fstar_reindex` `exact`, so a naive re-cut breaks a green `exact`; the safe path is
  a new-def-then-bridge sequence larger than a fine-grained per-sentence step. conj-2 (the `_legs`
  discharge) is blocked on conj-1. `sorry` count 4→4. **Tripwire fires** (see recommendations).

## Subagent dispositions (5 dispatched, all returned)
- **lean-auditor `iter034`** (all 4 files): 0 critical, 3 major, 8 minor. All 4 headline groups
  **axiom-clean**. The 4 FBC sorries are "in-progress work honestly documented" (real proof steps,
  documented residual — NOT abandoned dead code). Major: deprecated `CategoryTheory.Sheaf.val`
  (→`ObjectProperty.obj`) at >20 sites in FlatBaseChange.lean (will hard-error on a future Mathlib
  bump); 5 `maxHeartbeats` comments placed before the directive instead of after (linter). Minor:
  `show`→`change`, unused simp args, non-`only` simp. → recommendations.
- **lean-vs-blueprint-checker** ×4 (all prover-touched files), 0 must-fix-this-iter on any:
  - `grassmanniancells`: faithful + sorry-free, 62 decls. 2 major: 9 `private` GR decls pinned in
    blueprint `\lean{}` (names not externally verifiable — pre-existing); stale `lem:gr_separated`
    NOTE (**FIXED this review**).
  - `quotscheme`: faithful, 29 decls. 4 major: stale NOTE on the P1 keystone (**FIXED this review**);
    6 P1-keystone helpers lack blueprint blocks; 4 gap1-assembly decls absent (blueprint-acknowledged);
    2 documented skeleton signature gaps.
  - `fbcglobal`: axiom-clean, no placeholders, 18 decls. 3 broken blueprint pins (major) + 2
    unreferenced substantive decls (minor) — the 13-15 new decls need blueprint blocks.
  - `fbc`: 48 decls, 43 correct. 4 sorries (honest in-progress); 3 stale pins to non-existent
    `_link_*` decls (superseded direct-on-sections, to be removed iter-035); 2 new conj-0 decls
    need blueprint blocks.

## Blueprint markers updated (manual)
- `Picard_GrassmannianCells.tex`, `lem:gr_separated`: replaced stale iter-033 `% NOTE` ("the pinned
  decl `Grassmannian.isSeparated` does NOT yet exist … only a doc-comment reduction remains") with a
  RESOLVED-and-axiom-clean note describing the route (b) assembly.
- `Picard_QuotScheme.tex`, `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`: replaced stale `% NOTE`
  ("the pinned Lean decl … does NOT yet exist") with a RESOLVED-and-axiom-clean note describing the
  5-step affine descent + the general `isIso_fromTildeΓ_presentationPullback` form.

No `\leanok` touched (owned by `sync_leanok`). No `\mathlibok` added this review (the new decls are
bespoke project infra, not Mathlib re-exports).

## Notes (LOW)
- The retained abandoned direct-on-sections body beneath the FBC `_legs` sorry is appropriately
  documented (auditor: retain as-is), not rot.
- `sync_leanok` ran for the current tree (iter 34) — remaining marker state is the script's verdict.
