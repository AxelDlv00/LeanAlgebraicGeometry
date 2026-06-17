# Session 16 (iter-016) — review

## Metadata
- **Iteration / session**: iter-016 / session_16
- **Project sorry count**: 2 → 2 (no change). The two are `CechAcyclic.affine`
  (L1-blocked, 1) and the frozen P5b `cech_computes_higherDirectImage` (1). All other
  files (`PresheafCech`, `FreePresheafComplex`, `AcyclicResolution`, `HigherDirectImage`)
  are sorry-free.
- **Net new code**: **+21 axiom-clean declarations** across three lanes, **0 new sorries**,
  **2 objective definitions landed** (`def:section_cech_complex`, `def:cech_free_presheaf_complex`).
- **Targets attempted** (3 parallel lanes): `CechAcyclic.affine` (prove), `PresheafCech.lean`
  (mathlib-build), `FreePresheafComplex.lean` (mathlib-build).
- All new declarations `lean_verify`'d to kernel axioms only `{propext, Classical.choice, Quot.sound}`.

## Per-target detail

### CechAcyclic.affine (PARTIAL — dependent-coefficient L3 port done; sorry stays, L1-blocked)
- **Done**: the full `CombinatorialCech.Dependent.*` section (9 private decls, all axiom-clean):
  `depTransport`, `cons_comp_zero_succAbove`, `comp_succAbove_swap`, `depDiff`, `depHomotopy`,
  `depHomotopy_spec` (`d∘h+h∘d=id`), `depDiff_eq_of_cocycle`, `depDiff_comp` (`d²=0`),
  `depDiff_exact` (`Function.Exact`). This is the varying-coefficient port (`M_{s_σ}`) of the
  iter-015 constant-coefficient L3 — the forward step the plan flagged.
- **Key technique**: abstract the away-localisation restriction maps as additive `δ`/`c` with
  three compatibility hypotheses (`hu` unit `c∘δ₀=id`, `hsh` shift `c∘δ_{k+1}=δ_k∘c`, `hcomm`
  coface-commute), keeping the alternating-sum cancellation fully decoupled from localisation and
  transport. `depTransport` (`subst; rfl`) isolates the dependent-index transport friction the
  constant proof avoided.
- **Errors hit + fixes** (from attempts_raw): unused section variable on `depTransport` → `omit
  [∀ m σ, AddCommGroup (A m σ)] in` (had to precede the docstring, not follow — "unexpected token
  'omit'"); `comp_succAbove_swap` rewrite pattern `?r•?x+?s•?x` not found → reorder to
  `rw [hcomm σ j i (t _), depTransport (comp_succAbove_swap σ j i).symm t, ← add_smul, combSign_flip j i]; simp`.
- **Blocker (L1, unchanged)**: closing the top-level sorry needs to (1) reduce
  `IsZero ((CechComplex f 𝒰 F).homology p)` to a `Function.Exact` over `R`-modules, (2) identify
  the abstract `relativeCechComplexOfNerve` term `pushPullObj F (D(s_σ)↪Spec R)` sections with the
  away-localised modules `∏_σ M_{s_σ}` and its differential with the alternating localisation
  coboundary, (3) discharge `hu`/`hsh`/`hcomm` and feed `depDiff_exact` through
  `exact_of_isLocalized_span`. Step 2 is the deep gap: no project-local sheaf-section infrastructure
  (sections of `pushPullObj` over basic opens = `IsLocalizedModule.Away`; pushforward along `f`;
  cosimplicial→cochain differential). Mathlib has `Modules.Tilde` pieces
  (`IsLocalizedModule (.powers f) (tilde.toOpen M (basicOpen f)).hom`, `isUnit_algebraMap_end_basicOpen`)
  but the quasicoherent `(Spec R).Modules`→`tilde M` connection is absent. This is a separate
  ~150–250 LOC mathlib-build lane, **not** a tactic-blocked body fill.

### PresheafCech.lean (section side — `sectionCechComplex` SOLVED; hom-id blocked cross-file)
- **Done (+4 axiom-clean)**: `sectionCechCosimplicial`, `sectionCechComplex`
  (= `def:section_cech_complex`, the file's #1 objective), `freeYonedaHomEquiv_apply` (generator
  formula), `freeYonedaHomAddEquiv` (the additive upgrade = the per-term hom-id building block).
- **Build**: `sectionCechComplex` as `(alternatingCofaceMapComplex Ab.{u}).obj sectionCechCosimplicial`;
  degree-`p` object `∏ᶜ_σ F.presheaf.obj (op (⨅_k U(σ k)))`. `map_id`/`map_comp` close via
  `Pi.hom_ext` + `simp [Pi.lift_π, comp_toOrderHom]` + `Subsingleton.elim` on `(Opens X)ᵒᵖ` homs
  (proof-irrelevance). Codomain `Ab` (not `O_X(U)-modules`) — matches `F.presheaf : … ⥤ Ab` and the
  Stacks source quote.
- **Blocked**: `cechComplex_hom_identification` needs `cechFreePresheafComplex` (other file) to even
  state the LHS; the file-independent generic ⨁/∏ hom-equiv is Mathlib-absent and shape-dependent on
  the free file → deferred to the joint step (now unblocked: free file landed this iter).

### FreePresheafComplex.lean (free side — `cechFreePresheafComplex` SOLVED; quasi-iso is next)
- **Done (0→8 axiom-clean)**: `freeYoneda`, `coverOpen`, `coverInterOpen`, `coverInterOpen_comp_le`,
  `cechFreeSimplicial` (the simplicial backbone), `cechFreePresheafComplex`
  (= `def:cech_free_presheaf_complex` deliverable), `cechFreePresheafComplex_X`,
  `sigma_ι_eqToHom_transport`.
- **Design decisions**: `[Finite 𝒰.I₀]` added (needed for `HasCoproductsOfShape`); `∐` (coproduct)
  used — the lvb-checker **confirmed coproduct-vs-biproduct is NOT a discrepancy** (= notation only
  for finite index; `Hom(∐,F)=∏Hom` is exactly what the section complex consumes).
- **Reusable technique** (simplicial functor over `Sigma`): `Sigma.hom_ext; intro σ; Sigma.ι_desc`;
  index equality `e` via `funext; simp [unop_comp, comp_toOrderHom]`; transport `Sigma.ι` across `e`
  with `sigma_ι_eqToHom_transport` (`subst e; simp`); collapse `homOfLE = eqToHom` via
  `Subsingleton.elim` + `eqToHom_map`; combine with `← Functor.map_comp; congr`.
- **Next (validated route, not built)**: `cechFreeComplex_quasiIso` needs the augmentation object
  `O_𝒰` (image presheaf of `∐_i freeYoneda(U_i) → PresheafOfModules.unit`) + augmentation map first
  — a definitional task. Route confirmed: `PresheafOfModules.evaluation.PreservesHomology` holds by
  `inferInstance`, so an objectwise sectionwise contracting homotopy (same combinatorial content as
  `CombinatorialCech.*` L3 in CechAcyclic) suffices. **Dead end (re-confirmed): `ExtraDegeneracy`.**

## Key findings / patterns discovered
- **Dependent-coefficient combinatorial Čech (L3 port)**: abstract restriction maps as additive
  `δ`/`c` + three compat hypotheses (`hu`/`hsh`/`hcomm`); the alternating-sum cancellation and
  `d²=0` (via the `(j,i)↦(j.succAbove i, i.predAbove j)` sign-reversing involution +
  `Finset.sum_involution`) transfer verbatim from the constant case; transport friction isolated to
  a one-line `depTransport`.
- **Simplicial/cosimplicial object over a `Sigma`/`Pi` of representables**: the `map_id`/`map_comp`
  obligations are dependent-index `Sigma.ι`/`Pi.π` bookkeeping; close with `*.hom_ext` + the
  `ι_desc`/`lift_π` simp set + an `eqToHom`-transport helper + `Subsingleton.elim` on thin-category
  (Opens X) homs. Then take `alternating{Face,Coface}MapComplex` to get `d²=0` for free.
- **`evaluation.PreservesHomology` for `PresheafOfModules`** holds by `inferInstance` — homology of a
  complex of presheaves of modules is objectwise/sectionwise; enables objectwise contracting-homotopy
  proofs.

## Subagent reports (read; findings landed in recommendations.md)
- `lean-auditor-iter016` — 7 files, 0 must-fix, **9 major STALE comments** (no `\leanok`/axiom
  issues): `AcyclicResolution.lean` and `CechHigherDirectImage.lean` comment blocks describe
  `pushPullMap_comp`/`CechNerve`/`rightDerivedIsoOfAcyclicResolution` as "remaining" when all are
  proved; `PresheafCech.lean`/`FreePresheafComplex.lean` module docstrings list decls that don't
  exist yet. See `.archon/task_results/lean-auditor-iter016.md`.
- `lean-vs-blueprint-checker-cechacyclic` — sound; 1 known-pin sorry, 9 Dependent helpers need
  bundling. `.archon/task_results/lean-vs-blueprint-checker-cechacyclic.md`.
- `lean-vs-blueprint-checker-presheafcech` — **2 must-fix blueprint reconciliations** (Ab vs
  O_X(U)-modules in `def:section_cech_complex` + `lem:cech_complex_hom_identification`) + 1 major
  (`freeYonedaHomAddEquiv` missing `\lean{}`). `.archon/task_results/lean-vs-blueprint-checker-presheafcech.md`.
- `lean-vs-blueprint-checker-freepresheafcomplex` — Lean clean; 2 major blueprint gaps
  (`[Finite 𝒰.I₀]` absent from prose; `freeYoneda`/`coverInterOpen`/`cechFreeSimplicial` no
  `\lean{}`). `.archon/task_results/lean-vs-blueprint-checker-freepresheafcomplex.md`.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `def:section_cech_complex`: added `% NOTE` — Lean is
  `CochainComplex Ab ℕ`, prose says "O_X(U)-modules"; planner to reconcile to Ab.
- `Cohomology_CechHigherDirectImage.tex`, `lem:cech_complex_hom_identification`: added `% NOTE` —
  target category to be reconciled to Ab; bundle `\lean{…freeYonedaHomAddEquiv}` here.
- No `\mathlibok` added (all new decls are genuine project constructions, not Mathlib re-exports).
- No `\lean{...}` renames needed; no stale `\notready` (none present).
- `\leanok` untouched (sync_leanok ran for iter-016: added 2, removed 1).

## Notes (LOW)
- Stale planner comment `PresheafCech.lean:46–50` describes a planned `CochainComplex (ModuleCat …)`
  type that was never built (actual is `Ab`); flagged by lvb-checker, folded into the auditor's
  stale-comment cleanup recommendation.
- Blueprint-doctor: clean (no orphan chapters, no broken refs, no new axioms).
- sync_leanok-state.json: `iter=16` (current); remaining `\leanok` is the script's deterministic
  verdict — no laundering.
