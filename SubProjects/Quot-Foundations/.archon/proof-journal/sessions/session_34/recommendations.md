# Recommendations — for the iter-035 plan agent

## 0. Closest-to-completion / highest-value next moves

1. **GR-sep lane CLOSED.** `Grassmannian.isSeparated` is axiom-clean. The only remaining GR target
   is `lem:gr_proper` (valuative criterion, Nitsure §1) — a substantial separate build (was
   explicitly out of scope). If you open it, treat it as a fresh phase: blueprint + effort-break
   first; do not assign it as a one-round prove.
2. **QUOT gap1 P1 COMPLETE.** Next gap1 step is **D** (`section_localization_descent`), which
   consumes the GENERAL `isIso_fromTildeΓ_presentationPullback` (per affine cover member) +
   `exists_finite_basicOpen_cover_le_quasicoherentData` + `isIso_fromTildeΓ_iff_isLocalizedModule_restrict`
   (all already in-file). **Blocker before dispatch:** the D blueprint block cites Stacks tag "01HA"
   (lemma-invert-f-sections / Hartshorne II.5.3) — the strategy-critic flagged the tag as
   uncorroborated. **Verify the tag against the source before writing the D blueprint quote.**
3. **FBC-B chain is gated on FBC-A.** The module-level core (`baseChangeGammaEquiv`) is done, but
   every downstream geometric link (`base_changed_equalizer_diagram`, `flat_base_change_separated`,
   `…_mayer_vietoris`) needs FBC-A's `affineBaseChange_pushforward_iso` to identify the base-changed
   sheaf `M'`. Do NOT dispatch the FBC-B chain assembly until FBC-A's affine sorry closes.

## 1. FBC-A — TRIPWIRE FIRES: ONE more conjugate round, then escalate (HIGH)

iter-034 closed conj-0 (the two `pullbackComp = leftAdjointCompIso` foundation lemmas, axiom-clean)
but did NOT close `_legs`/`gstar_transpose`. Per the plan's firm tripwire (do not re-date):
- **iter-035 runs ONE fine-grained re-break** of the conjugate route: conj-1 (re-cut
  `base_change_mate_codomain_read_legs` as a NEW `leftAdjointCompIso`-native def
  `…_codomain_read_legs_conj`, then BRIDGE to the existing read via conj-0′ so the green concrete
  `exact` is preserved), then conj-2 (discharge `_legs` via
  `obtain ⟨_, rfl⟩ := (conjugateEquiv …).surjective` → `apply (conjugateEquiv …).injective` → reassoc
  conjugate set, template `leftAdjointCompNatTrans₀₂₃_eq_conjugateEquiv_symm` at CompositionIso.lean:140).
- **If iter-035 also closes nothing, iter-036 escalates the single FBC-A crux to the user via
  TO_USER** (already pre-stated). 15+ iters / >7× budget — no further silent extension.
- **Do NOT re-assign direct-on-sections.** The `..._link_*` factor-telescoping route is ABANDONED;
  the `X.Modules` diamond makes every keyed `rw`/`simp`/`erw` dead and the term-mode splice bottoms at
  a cross-layer mate coherence with no term-mode form.

## 2. Coverage debt — 33 `lean_aux` unmatched nodes need blueprint blocks (HIGH)

`archon dag-query unmatched` = 33. I do not author informal prose; the planner must add blocks to
restore the 1-to-1 Lean↔blueprint map. Grouped by file:

**FlatBaseChangeGlobal.lean (15 — Cohomology_FlatBaseChange.tex, FBC-B section):**
`groundRing`, `rhoU`, `rhoU_comp`, `gammaModA`, `gammaResAHom`, `gammaResA`, `gammaResA_apply`,
`gammaResA_comp`, `leftRes`, `rightRes`, `toCover`, `leftRes_toCover`, `toCoverEqLocus`,
`gammaTopEquivEqLocus` (the H⁰-as-A-module-equalizer keystone), `baseChangeGammaEquiv` (the flat
base change payoff). `gammaTopEquivEqLocus` `\uses` the helper chain + the two `\mathlibok` sheaf
lemmas (`eq_of_locally_eq'`, `existsUnique_gluing'`) — note `gammaIsLimitSheafConditionFork` is NOT
used. `baseChangeGammaEquiv` `\uses gammaTopEquivEqLocus` + `lem:flat_preserves_equalizer_mathlib`.

**QuotScheme.lean (6 — Picard_QuotScheme.tex):**
`presentationPullbackιRestrict`, `opensMapEquivOfIso`, `opensMap_final_of_schemeIso`,
`pullbackSchemeIsoUnitIso`, `presentationPullbackOfSchemeIso`, `isIso_fromTildeΓ_presentationPullback`
(the general affine-open keystone — strictly more general than the pinned basic-open form; the form
gap1-D should consume). Dependency details in `task_results/AlgebraicJacobian/Picard/QuotScheme.md`.

**GrassmannianCells.lean (6 from this iter + 3 pre-existing — Picard_GrassmannianCells.tex):**
this iter: `toSpecZ`, `ι_toSpecZ`, `pullbackιIso_inv_fst`, `pullbackιIso_inv_snd`,
`chartTransition_comp_chartIncl`, `isSeparatedToSpecZ` (the morphism-form of `lem:gr_separated`;
could fold into that block's proof or get its own `lem:gr_separated_toSpecZ`). Pre-existing carry-over:
`rotMid`, `transitionInvImageMatrix`, `transitionInvPair`. Dependency details in
`task_results/AlgebraicJacobian_Picard_GrassmannianCells.lean.md`.

**FlatBaseChange.lean (2 from this iter + 1 pre-existing — Cohomology_FlatBaseChange.tex):**
`pullbackComp_inv_eq_leftAdjointCompIso_inv`, `pullbackComp_eq_leftAdjointCompIso` (the conj-0
foundation; blueprint as a Seam-2 conjugate-route subsection, `\uses`-wired into
`lem:base_change_mate_fstar_reindex_legs`). Pre-existing: `isIso_unitToPushforwardObjUnit_of_isIso'`.

## 3. Stale / broken blueprint pins to clean up (MEDIUM — planner prose)

`\lean{...}` corrections to non-existent decls are blueprint *prose* surgery (block/pin removal),
so the planner owns these, not the review marker pass:
- **Cohomology_FlatBaseChange.tex**: 3 stale `\lean{}` pins to non-existent `_link_cancelEUnit`,
  `_link_cancelPullbackComp`, `_link_survivor` (superseded direct-on-sections; blueprint already
  marks them superseded — remove the pins/blocks now that the route is abandoned). The fbcglobal
  checker also flagged 3 broken FBC-B pins — reconcile when adding the FBC-B blocks (item 2).
- **Picard_GrassmannianCells.tex**: 9 `private` GR decls carry public-namespace `\lean{}` pins that
  don't resolve under `lake env lean` (pre-existing, breaks `sync_leanok` for those blocks). Either
  un-private the decls or drop the pins — a recurring carry-over from iter-031.

## 4. Deprecation / linter debt (MEDIUM — schedule a cleanup, not a blocker)

lean-auditor `iter034` (report: `logs/iter-034/lean-auditor-iter034-report.md`):
- **`CategoryTheory.Sheaf.val` deprecated → `ObjectProperty.obj` at >20 sites in
  FlatBaseChange.lean** (lines 294, 333, 336, 340, 370, 384, 386, 434, 485, 512, 515, 523, 572,
  577, 579, 580, 583, 584, 586, 605, 615). Will become a HARD ERROR on a future Mathlib bump. Worth
  a dedicated mechanical refactor pass before it breaks the build.
- **5 `maxHeartbeats` `set_option` comments placed BEFORE the directive** (FlatBaseChange.lean
  lines 979, 1415, 1543; plus the auditor noted similar in QuotScheme new code) — the linter wants
  the explanatory comment on the line AFTER. Minor.
- Minor: `show`→`change` (FBC 1119), unused simp arg `Functor.map_comp` (FBC 1496), non-`only`
  `simp [← Functor.map_comp]` (FBC 1092). Fold into the same cleanup pass.

## 5. Do-NOT-retry (blocked approaches)
- **FBC-A direct-on-sections** (`_link_*` factor telescoping): ABANDONED. The `X.Modules` diamond
  defeats all keyed tactics; term-mode bottoms at a cross-layer mate coherence with no term-mode form.
- **QUOT α-factorization route** (`IsOpenImmersion.lift` + `pullbackComp`): hits the
  `Functor.Final (Opens.map j.base)` open-immersion wall. Use the iso-only `Final` (via
  `opensMapEquivOfIso`) instead — already done for P1.
- **GR**: `convert!` and `pullback.map_fst`/`map_snd` do NOT exist in this Mathlib; `← Spec.map_comp`
  bare `rw` fails on the Scheme-cat diamond. (Now in Knowledge Base / the GR task_result.)

## 6. Reusable proof patterns landed this iter (also added to PROJECT_STATUS Knowledge Base)
- **Terminal `Spec ℤ` collapses separatedness glue for `Scheme.{0}`** — `specZIsTerminal.from` makes
  the structure morphism and per-chart identity pure `IsTerminal.hom_ext`; no `glueMorphisms`.
- **Element-level sheaf axioms beat the categorical product bridge** — `eq_of_locally_eq'` /
  `existsUnique_gluing'` on `⟨M.presheaf, M.isSheaf⟩` give H⁰-equalizer bijectivity without matching
  `∏` in `Ab` with `Π`-types.
- **`pullbackComp = leftAdjointCompIso` via `conjugateEquiv.injective`** — the project pseudofunctor
  coherence is the abstract composite-adjunction iso; a 2-line proof, foundation for the FBC conjugate
  re-encoding.
- **`SheafOfModules.pullback (φ.inv.toRingCatSheafHom)` vs `Scheme.Modules.pullback φ.inv`** — defeq
  but the bundled-instance form breaks `asIso`'s `IsIso` synthesis; state with the `SheafOfModules` form.
