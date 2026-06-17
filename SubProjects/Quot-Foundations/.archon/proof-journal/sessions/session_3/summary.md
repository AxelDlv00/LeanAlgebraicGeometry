# Session 3 (iter-003) — Review Summary

## Metadata
- Iteration / session: 003 / session_3
- Model: claude-opus-4-8
- Prover lanes dispatched: 2 — FBC-A (`Cohomology/FlatBaseChange.lean`), GF-alg (`Picard/FlatteningStratification.lean`)
- Sorry-bearing decls (the two prover files):
  - FBC: 3 → **3** (count flat, but composition vastly improved — see below)
  - GF: 2 → **5** (structural scaffold increase — the full Nitsure §4 chain is now declared)
- Build: GREEN throughout (`lake env lean` exit 0 on both files; only deprecation/linter warnings).
- Axioms on all newly-proved decls: `propext, Classical.choice, Quot.sound` (clean; no `sorryAx`).

## FBC-A lane (`AlgebraicJacobian/Cohomology/FlatBaseChange.lean`)

The monolithic crux sorry in `pushforward_base_change_mate_cancelBaseChange` was
decomposed into the blueprint's `\uses`-linked chain and proved leaves-first. Three leaf
lemmas landed fully proved + axiom-clean, the parent mate lemma is now a proved assembly
modulo one concrete residue, and two new helper `def`s were added.

- **`pullback_fst_snd_specMap_tensor` (L1) — SOLVED, axiom-clean** (line 706).
  `exact pullbackSpecIso_inv_fst ↑R ↑A ↑R'` (and `_snd`). Key insight: under
  `letI := φ.hom.toAlgebra`, `Spec.map φ` is *defeq* to
  `Spec.map (CommRingCat.ofHom (algebraMap R A))`, so Mathlib's `pullbackSpecIso`
  over the `algebraMap` cospan IS the same `pullback.fst (Spec.map φ) (Spec.map ψ)`
  — no bridging lemma. Uses Mathlib's tensor order `A ⊗[R] R'` (blueprint writes
  `R' ⊗_R A`; faithful re-orientation, now noted in the chapter).
- **`base_change_mate_domain_read` (L2, Θ_src) — SOLVED, axiom-clean** (line 734).
  Composite of `mapIso`'d tilde dictionaries + `tilde.toTildeΓNatIso`; domain `g^*(f_* M̃)`
  involves only genuine `Spec`-maps so dictionaries apply directly. Target `R' ⊗_R M`.
- **`base_change_mate_codomain_read` (L3, Θ_tgt) — SOLVED, axiom-clean** (line 770).
  Two attempts:
  - Attempt 1: `asIso ((pullbackPushforwardAdjunction e.hom).unit.app W₀)` → **failed**:
    `failed to synthesize IsIso (...unit.app W₀)` (per-object `IsIso` doesn't auto-fire
    from `IsIso adj.unit`).
  - Attempt 2: **success** — introduced two NEW helper defs so the functor-level unit-iso
    fires, then `(asIso (pullbackPushforwardAdjunction e.hom).unit).app W₀`. Target
    `(A ⊗_R R') ⊗_A M`.
- **NEW helpers (coverage debt — no blueprint block yet):**
  - `pullbackIsoEquivalenceOfIso (f) [IsIso f] : Y.Modules ≌ X.Modules` —
    `Equivalence.mk (pullback f) (pullback (inv f))`, unit/counit from
    `pullbackComp`/`pullbackCongr`/`pullbackId`, coherence discharged by default `aesop_cat`.
  - `pullback_isEquivalence_of_iso` (instance) — `(pullback f).IsEquivalence` from the above.
- **`base_change_mate_generator_trace` (L4) — PARTIAL (`sorry`, the isolated crux)** (line 830).
  Stated as `IsIso (Θ_src⁻¹ ≫ Γ(α) ≫ Θ_tgt)` (mirrors the parent's `IsIso` pin). The
  residual obstacle is now a CONCRETE tensor map `R'⊗_R M ⟶ (A⊗_R R')⊗_A M`, not an
  abstract sheaf-map's Γ. Route documented: build the R'-linear regrouping equiv
  `(A⊗_R R')⊗_A M ≅ R'⊗_R M` (heterobasic `AlgebraTensorModule.comm` + `cancelBaseChange`)
  and `suffices conjugate = regroupEquiv.toModuleIso.hom`. `rw [ConcreteCategory.isIso_iff_bijective]`
  is strictly harder, not taken.
- **`pushforward_base_change_mate_cancelBaseChange` (parent) — PARTIAL, direct proof now
  sorry-free** (line 869). `set D,C,Γα`; `Γα = D.hom ≫ (D.inv ≫ Γα ≫ C.hom) ≫ C.inv`;
  `simp [Category.assoc]; infer_instance`. The old monolithic sorry + stale comment are
  REMOVED; only the L4 leaf remains, transitively. **Closes automatically when L4 lands.**
- `affineBaseChange_pushforward_iso` (line 951) and `flatBaseChange_pushforward_isIso`
  (line 973) — pre-existing sorries, untouched / downstream-deferred per PROGRESS.

## GF-alg lane (`AlgebraicJacobian/Picard/FlatteningStratification.lean`)

The full 5-lemma Nitsure §4 dévissage chain was scaffolded (all blueprint-pinned names now
exist as decls, so the `\lean{}` pins resolve), and the genuine leaves were proved.

- **`exists_free_localizationAway_of_torsion` (L1) — SOLVED, axiom-clean** (line 168).
  Encode `M_K = 0` as `Subsingleton (LocalizedModule (nonZeroDivisors A) M)`; `choose`
  per-generator non-zero-divisor annihilators over a finite `B`-generating set
  (`Module.Finite.fg_top`); `f := ∏`; `f • m = 0` by `Submodule.span_induction`; finish
  `LocalizedModule.subsingleton_iff.mpr` + `Module.Free.of_subsingleton`. **Key insight:**
  `f•(b•x)=b•(f•x)` for `f:A, b:B` is NOT an automatic `SMulCommClass` — prove it via
  `IsScalarTower.algebraMap_smul` + `smul_smul` + `mul_comm`.
- **`exists_free_localizationAway_of_shortExact` (L3) — PARTIAL (signature + `f` witness;
  core `sorry`)** (line 220). `f := f' * f''`. 3-step plan found:
  (1) `LocalizedModule.map_exact (powers (f'*f''))` on `restrictScalars`'d `i,q`;
  (2) free transport via `Module.free_of_isLocalizedModule` (ring-side `IsLocalization.Away.mul`
  available; **module-side localization map `M'_{f'} →ₗ M'_f` + its `IsLocalizedModule`
  instance is the missing plumbing**); (3) SES with free quotient splits ⟹ `M_f ≅ M'_f ⊕ M''_f`.
  Dead end avoided: the `freeLocus`-openness shortcut does NOT apply (`M` not f.p. over `A`).
- **`exists_localizationAway_finite_mvPolynomial` (L4) — PARTIAL (signature typechecks;
  `sorry`)** (line 268). Encoding binds instance-existentials (`∃ (_ : Algebra …) …`),
  required to typecheck. **Flagged by prover AND the gf checker as bulky/fragile** — see
  recommendations.
- **`exists_free_localizationAway_polynomial` (L5) — PARTIAL (base case proved; inductive
  step `sorry`)** (line 307). Attempt 1 (`induction d`) **failed**:
  `failed to synthesize Module (MvPolynomial (Fin 0) A) N` — `induction d`
  mis-generalizes the `d`-dependent module instances. Attempt 2 (`rcases Nat.eq_zero_or_pos d`)
  closed `d=0` clean via `MvPolynomial.isEmptyAlgEquiv` + `Module.Finite.equiv/trans`;
  `d ≥ 1` generic-rank dévissage is the surviving residue.
- **`genericFlatnessAlgebraic` (assembly) — PARTIAL** (line 370). Primary route (M finite/A)
  closed (unchanged); residue branch replaced the stale "Mathlib doesn't provide" comment
  with the explicit assembly route. **Blocker:** the prime-filtration induction principle's
  motive carries only `[Module B N]`; reconciling a defeq-compatible `Module A N` (via
  `Module.compHom`) against the given `IsScalarTower A B M` is the substantial plumbing —
  worth wiring only after L3/L4/L5 close.
- `genericFlatness` (geo wrapper, line 432) — `not_started`, deferred per PROGRESS.

## Cross-cutting findings / patterns

- **Section-level mate via tilde dictionaries (FBC pattern):** read an abstract
  pullback/pushforward composite on global sections by chaining the two proved tilde
  dictionaries (`pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`) + `toTildeΓNatIso`,
  reducing an "abstract sheaf-map's Γ is iso" goal to a concrete tensor-module map.
- **Pullback-along-iso is an equivalence:** to get a per-object unit-iso for an iso `f`,
  build `(pullback f).IsEquivalence` so `instIsIsoFunctorUnitOfIsEquivalence` fires, then use
  the functor-iso `.app` form — `asIso (adj.unit.app x)` fails, `(asIso adj.unit).app x` works.
- **A/B scalar non-commutation:** `f•(b•x)=b•(f•x)` for `f:A, b:B` over a scalar tower is
  NOT free; route through `algebraMap A B`.
- **`induction d` vs `rcases` on `d`-dependent instances:** when module instances depend on
  the recursion variable, `induction d` mis-generalizes; a faithful induction must
  ∀-quantify the module.

## Subagent reports (this session)
- **lean-auditor** (iter003): 5 files, **0 must-fix**, 2 major, 4 minor, 0 excuse-comments.
  Report: `task_results/lean-auditor-iter003.md`.
- **lean-vs-blueprint-checker** (fbc): 25 decls, **0 must-fix**, 1 major + 2 minor (all
  blueprint-doc gaps, since addressed by markers). Tensor-order = faithful re-orientation.
  Report: `task_results/lean-vs-blueprint-checker-fbc.md`.
- **lean-vs-blueprint-checker** (gf): 9 decls (9/9 coverage), **0 must-fix**, 2 major
  (blueprint-adequacy: L4 encoding undocumented; `gf_free_moduleFinite` prose understates
  hypotheses), 1 minor. Report: `task_results/lean-vs-blueprint-checker-gf.md`.

All three reports confirm the Lean is faithful; every `sorry` is honest scaffolding, no
weakened-wrong defs, no excuse-comments, no unauthorized axioms.

## Notes (low severity)
- 21-site `CategoryTheory.Sheaf.val` deprecation cluster in `FlatBaseChange.lean` (proved
  code; will break on a future Mathlib bump). Two over-100-char lines. Missing
  `set_option autoImplicit false` at FBC file top (inconsistent with siblings).
- Comments across all files carry predecessor-project iter numbers (iter-173…iter-241)
  that don't map to Quot-Foundations' log — cosmetic.
- Blueprint doctor (`logs/iter-003/blueprint-doctor.md`): **no structural findings**
  (no orphan chapters, all `\ref`/`\uses` resolve, no stray axioms).

## Blueprint markers updated (manual)
- `Cohomology_FlatBaseChange.tex`, `lem:base_change_mate_generator_trace`: added two
  `% NOTE (iter-003):` — (a) the decl records the `IsIso` corollary, not the literal
  generator formula; (b) the `A ⊗[R] R'` vs `R' ⊗_R A` tensor-order convention. (fbc M1+m1)
- `Cohomology_FlatBaseChange.tex`, `lem:pushforward_base_change_mate_cancelBaseChange`:
  refreshed the stale iter-002 `% NOTE` line — the direct proof body is no longer
  sorry-bodied; the residual sorry is transitive via `lem:base_change_mate_generator_trace`. (fbc m2)
- `Picard_FlatteningStratification.tex`, `lem:gf_noether_clear_denominators`: added
  `% NOTE (iter-003 review)` flagging the undocumented instance-existential encoding and
  the (a)/(b) writer decision. (gf major 1)
- `Picard_FlatteningStratification.tex`, `lem:gf_free_moduleFinite`: added
  `% NOTE (iter-003 review)` flagging that the prose understates the actual `[Module.Finite A B]`
  / `[Module.Finite B M]` hypotheses. (gf major 2)
- No `\mathlibok` added (all Mathlib anchors already correctly marked; confirmed by both checkers).
- No `\lean{...}` renames (all pins resolve verbatim). No stale `\notready` (none present).
- `\leanok` untouched — `sync_leanok` ran for iter-003 (added 21, removed 0).
