# Session 58 (iter-058) — Summary

## Metadata
- Global active sorry: **10** (FBC 4 parked, QuotScheme 4, FlatteningStratification 1, SectionGradedRing 1).
- Touched files: `FlatteningStratification.lean` (1→1), `SectionGradedRing.lean` (4 refactor-introduced
  functoriality sorries all re-closed; +1 new `relTensorProj.naturality`).
- Lanes: GF (close `flatV`), SNAP (fill carrier-aligned functoriality sorries + build `relTensorActL`/`actR`).
  GR blueprint-paused (cocycle chapter written; prover deferred to iter-059).
- Build GREEN both modules. New decls verified `{propext, Classical.choice, Quot.sound}` (first-hand on
  `flat_of_ringEquiv_semilinear`, `flat_localization_models`, `relTensorActL`/`actR`, `isColimitCofork`).
- sync_leanok ran (iter 58, sha a139365, +5/-3).

## GF — `genericFlatness` `flatV` (FlatteningStratification.lean, partial)
Reduced the lone `flatV` sorry from an opaque goal to a **single semilinearity equation** (STEP-3),
everything else proved + compiling. 4 new axiom-clean reusable helpers built:
- `gf_flat_isLocalizedModule_sameBase` — B1′ model-free form of `gf_flat_localizedModule_sameBase`
  (via `IsLocalizedModule.iso` + `Module.Flat.of_linearEquiv`). The consumer form actually called.
- `flat_of_ringEquiv_semilinear` — flatness transfers across `e : R ≃+* R'` + `e`-semilinear additive
  iso `l : M ≃+ M'`. Proof: `M'` is the base change `R'⊗[R]M` (lift of `l` is `R'`-linear, inverse
  `y↦1⊗l⁻¹y`), so `Module.Flat.isBaseChange` descends. (Build path hit `expected token` from a misplaced
  `open scoped TensorProduct in`; fix = put it on the line **above** the docstring.)
- `flat_localization_models` — flatness of a localization is model-independent (`Rₛ,Mₛ` vs `Rₛ',Mₛ'`),
  via `IsLocalization.algEquiv` + `IsLocalizedModule.linearEquiv` semilinearity feeding the prior helper.
  (Synth-failure `MulActionHomClass (Rₛ≃+*Rₛ') …`; fix = route through `IsLocalization.algEquiv … .toRingEquiv`.)
- `isLocalizedModule_powers_restrictScalars` — descends `IsLocalizedModule (powers (algebraMap A B f)) φ`
  to `IsLocalizedModule (powers f) (φ.restrictScalars A)` along the scalar tower.

Assembly inside `flatV` (compiling): STEP 1 `hMifFlat : Module.Flat Av Γ(F,Df̄)` (free→flat over `A_f`
via `free_localizationAway_of_free_of_eq_mul` + `flat_localization_models` + the `appLE` commuting
square for the scalar tower); STEP 2 `hN'flat : Module.Flat Av Γ(F,Dḡ)` (`gf_flat_isLocalizedModule_sameBase`
at `powers gbar'`). STEP 3 = OPEN: transport along `hbg : X.basicOpen gbar' = X.basicOpen g`; reduced via
`flat_of_ringEquiv_semilinear (RingEquiv.refl _) l ?_` to the single equation `l (c•x) = c•l x`.

Dead ends: `rw [←hbg]` / `hbg ▸` rejected (motive ill-typed — `modV` depends on `D g`); transport MUST use
an explicit equiv. `set Wi := …` splits the pre-existing `gbar` hyp → use `let Wi := …`.

## SNAP — coequalizer rows (SectionGradedRing.lean)
**Closed all 4 carrier-aligned functoriality sorries** (`relTensorDomainPresheaf`/`relTensorTriplePresheaf`
`map_id`/`map_comp`) and **built `relTensorActL`+`relTensorActR` fully axiom-clean** (the
progress-critic CHURNING corrective deliverable). New private helpers `objRestrict_id`/`objRestrict_comp`.

- **Functoriality:** element-level `map_tmul` FAILED — the iter-056 carrier wall reappeared on the MIDDLE
  ring factor (`objRestrict` only fixed the P/Q factors); the ring factor's `Module ℤ` instance is
  rfl-defeq but syntactically distinct so `map_tmul`'s motive won't fire. WIN: collapse each restriction
  to `LinearMap.id`/comp at the **LinearMap level** (`objRestrict_id`/`objRestrict_comp` + inline `hR`
  for the ring factor), then `TensorProduct.map_id`/`map_comp` + `rfl`. The instance diamond never bites
  at LinearMap level. GOTCHA: `P.presheaf` is `Ab/AddCommGrpCat`-valued ⇒ use `AddCommGrpCat.hom_id`/
  `hom_comp`, NOT `ModuleCat.*`.
- **actL/actR:** component `ofHom (actLmap …).toAddMonoidHom`; naturality via a LinearMap `have key`
  square (`TensorProduct.ext'`), tmul leaf closed by `change`-to-fully-reduced-form + `congr 1` +
  `PresheafOfModules.map_smul`. The single math fact is `map_smul`; `change`-to-reduced is the reliable
  escape from the `map_tmul` matching wall. Transport to the categorical square via
  `AddCommGrpCat.hom_ext` + `simpa … using LinearMap.congr_fun key z`.
- **`relTensorProj` (partial):** component `app` PROVEN (the genuinely-uncertain apex-carrier
  identification via `tensorObj_obj` defeq landed, sorry-free). `naturality` = 1 documented sorry:
  blocked on a `forget₂ CommRingCat→RingCat` carrier mismatch (relative-tensor base ring
  `R(V)=(X.sheaf.obj⋙forget₂).obj V` vs the `CommRingCat` carrier `projL` is built over); any
  `show`/`change` re-elaborates `projL` and demands the `RingCat`-carrier `Module` instance (defeq but
  not syntactically registered). FIX: a `restrictScalars`/`forget₂` carrier-transport lemma, OR prove
  naturality at the `ModuleCat`-presheaf level before forgetting to `Ab` (where `tensorObj_map_tmul`
  applies directly). Dead ends ruled out: (i) `simp [hom_comp, hom_ofHom, comp_apply]` doesn't peel
  the categorical `≫` here; (ii) `show`/`change` to the peeled form re-elaborates `projL`.

## Subagent reviews (this phase)
- **lean-auditor iter058** (0 must-fix / 3 major / 3 minor) — all decls genuine, no laundering, the 2
  sorries honest. Major findings are all STALE COMMENTS in `.lean` (review agent can't edit): FLAT L47-53
  ("polynomial core missing" — it exists), L1957 ("`sorry` this iter" for now-closed
  `genericFlatnessAlgebraic`), SNAP L660-712 ("DEFERRED" block describing actL/actR as blocked though
  proven above it). Report: `task_results/lean-auditor-iter058.md`.
- **lvb flat-iter058** (3 major) — 4 new helpers lack `\lean{}` pins; STEP-3 sketch under-specified;
  stale L1957 comment. Report: `task_results/lean-vs-blueprint-checker-flat-iter058.md`.
- **lvb snap-iter058** (4 major / 1 minor) — `relTensorActR`/`relTensorProj` no blueprint block;
  `lem:relativeTensor_as_coequalizer` sketch silent on the `forget₂` carrier obstacle;
  `lem:relativeTensor_objectwise_coequalizer` missing `\leanok` (multi-pin sync miss, fixed manually
  below); 9 private decls carry public-name pins (potential sync blind spot).
  Report: `task_results/lean-vs-blueprint-checker-snap-iter058.md`.

## Blueprint markers updated (manual)
- `Picard_SectionGradedRing.tex`, `lem:relativeTensor_objectwise_coequalizer`: added `\leanok` (manual
  override). Justification: the statement block carries a 21-pin multi-line `\lean{}` list; all 21
  `RelativeTensorCoequalizer.*` decls are sorry-free (lvb snap-iter058 verified; iter-053 KB confirms
  "DONE axiom-clean"; I re-verified the keystone `isColimitCofork` = `{propext, Classical.choice,
  Quot.sound}`). `sync_leanok` missed it — a multi-pin-block handling gap (it appears to check only the
  first pin). Placed as `\begin{lemma}[title]\leanok` (after the optional title).

## Blueprint-doctor
0 findings (every chapter `\input`'d, all `\ref`/`\uses` resolve, no `axiom` decls).

## leandag
gaps=0. unmatched=11 lean_aux (10 new helpers this iter + pre-existing private `opensTopology`) — all
listed in `recommendations.md` for the planner to blueprint.

## Key findings / patterns
- **LinearMap-level collapse beats element-level `map_tmul`** when a ⊗-factor's module instance is
  rfl-defeq-but-syntactically-distinct: rewrite each factor to `LinearMap.id`/comp, then
  `TensorProduct.map_id`/`map_comp`. The diamond never bites at LinearMap level.
- **`change`-to-fully-reduced-form** is the reliable escape from the `simp`/`rw` `map_tmul` matching wall
  (bypasses the instance diamond; `actLmap_tmul`/`map_tmul` are rfl in context).
- **`Ab`/`AddCommGrpCat`-valued presheaf** ⇒ `(P.presheaf.map f).hom` is an `AddMonoidHom`; reductions
  need `AddCommGrpCat.hom_id`/`hom_comp`, not `ModuleCat.*`.
- **`open scoped … in`** goes on the line ABOVE the docstring, not between docstring and `theorem`.
- **`flat_of_ringEquiv_semilinear`** (base-change `Module.Flat.isBaseChange`) is the general workhorse
  for flatness-under-semilinear-iso — reusable for any `eqToHom`/presheaf-iso transport of flatness.

## Recommendations
See `recommendations.md`.
