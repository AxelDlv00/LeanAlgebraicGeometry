# Session 21 (iter-021) review

## Metadata
- **Project sorry**: 2 → 2 (no regression). Both intentional: superseded relative-form
  `CechAcyclic.affine` (`CechAcyclic.lean:110`) + frozen P5b (`CechHigherDirectImage.lean:679`).
- **Build**: GREEN; touched file (CechAcyclic.lean) diagnostic-clean, `lean_verify` axioms =
  {propext, Classical.choice, Quot.sound} on every new decl.
- **Lanes planned**: 2 (CechAcyclic, FreePresheafComplex). **Lanes that actually ran**: 1
  (CechAcyclic). FreePresheafComplex was **NOOP-dropped by plan-validate** (see below).
- **+5 axiom-clean declarations** (+1 private helper) on CechAcyclic.lean; **0 new sorries**;
  **0 named blueprint targets landed** (the abstract sub-pieces of step (c) landed under
  helper names; the named targets `sectionCechCofaceMatch`/`sectionCechAbExact`/
  `sectionCech_homology_exact`/`sectionCech_affine_vanishing` remain unbuilt).

## THE headline finding — Route 2's corrective never ran (noop trap recurrence)

`logs/iter-021/meta.json` shows `planValidate.objectivesNoop =
["AlgebraicJacobian/Cohomology/FreePresheafComplex.lean"]`, `objectives = 1`. Only the
CechAcyclic prover was dispatched.

**Root cause** (verified against `PROGRESS.md`): the noop filter drops any objective naming an
*existing* `.lean` file with *zero* open sorries unless the **same physical line** that bears the
`.lean` path also carries a scaffold keyword (`scaffold` / `does not yet exist` / `declarations
for` / `add the import`). PROGRESS.md line 45 (the FreePresheafComplex path) reads
"build the differential-match + nonempty" — no keyword; the keyword "do not yet exist (scaffold
them)" sits on line 46. → dropped. CechAcyclic survived only because it carries the line-110
sorry (the filter exempts files with sorries), even though its keyword is ALSO on the wrong
physical line (line 72, path on line 71).

This is **the same trap that cost the entire iter-017 prover phase** (recorded in Archon memory),
recurring in a subtler form: this time the keyword was present but split onto the line *after* the
path. The progress-critic had marked Route 2 CHURNING and the planner's D1 was a careful,
sanctioned corrective (attack the `cechFreeEvalEngineIso` differential match first). None of it
ran. Route 2 is now effectively at its 4th iter with no `cechFreeComplex_quasiIso` and no new
attempt — the escalation clock the critic set has elapsed with zero data.

## Target detail

### CechAcyclic.lean — P3 L1 step (c) abstract homological half + step (d) handoff
Five axiom-clean decls forming the **complete abstract categorical→module homology bridge** of
blueprint steps (c1)–(c3):

1. `sectionCechProductEquiv` (c1) — `ToType(∏ᶜ_σ F_σ) ≃ ∏_σ ToType(F_σ)` via `Concrete.productEquiv`.
2. `sectionCechProductEquiv_apply` — `rw`-friendly restatement of `Concrete.productEquiv_apply_apply`
   (the bare Mathlib lemma will NOT `rw`/`simp` here — see Patterns).
3. `sectionCechFaceRestr` (def) — the `i`-th face restriction, factored as a named def
   **specifically to dodge a `whnf` heartbeat blow-up** in the dependent lemma's statement.
4. `sectionCech_objD_apply` (c2, ABSTRACT) — the `objD q` differential read through the product
   equivalence is `∑ᵢ (-1)ⁱ • faceRestr_i (…)`. Purely cosimplicial; **no sheaf identification**.
5. `sectionCech_isZero_homology_of_objD_exact` (c3 reduction) — `IsZero(homology (q+1))` from
   `Function.Exact` of the two consecutive `objD` underlying maps, via
   `exactAt_iff_isZero_homology` + `exactAt_iff'` + `ShortComplex.ab_exact_iff_function_exact`.

Plus private `ab_hom_finsetSum_apply` (Ab-morphism finite-sum application distributes).

**Step (d) (`sectionCech_affine_vanishing`) is blocked** on the *tilde F-bridge*: a per-coordinate
`AddEquiv φ_σ : ToType(F.presheaf.obj (op (⨅ₖ U(σ k)))) ≃+ SectionCechModule.dCoeff s M σ`
intertwining `sectionCechFaceRestr` with `dCoface`. The obstruction is reconciling **three
distinct presheaf accessors** — the `toPresheafOfModules` underlying-Ab presheaf vs the
`modulesSpecToSheaf` / `tilde.toOpen` ModuleCat sections. This is genuinely new infrastructure,
NOT a known-route gap. Once that single equiv+square family exists, step (d) is the mechanical
ladder assembly via `Function.Exact.of_ladder_addEquiv_of_exact` + decl 5 + the already-proved
`SectionCechModule.dDiff_exact` (step a). The prover wrote a precise handoff (items A/B/C in
`task_results/CechAcyclic.md`).

## Subagent findings (full reports linked)
- **lean-auditor** (`task_results/lean-auditor-iter021.md`): 0 critical, **1 major**, 2 minor.
  Major: the `SectionCechBridge` module doc (lines ~1200–1209) **overstates** the section's reach —
  it claims the abstract complex is moved to `dDiff` "and reads off homology vanishing," but the
  `faceRestr ↔ dCoface` identification is absent and decl 5 is *conditional*, not unconditional
  vanishing. Minor: unnecessary `classical` in `ab_hom_finsetSum_apply`; `(by simp)` side
  conditions in decl 5 would be more robust as `omega`/`norm_num`. PresheafCech.lean clean.
- **lean-vs-blueprint-checker** (`task_results/lean-vs-blueprint-checker-cechacyclic.md`):
  **0 must-fix**. The 5 additions are faithful and **do not over-claim** — `sectionCech_objD_apply`
  correctly covers only the abstract unfold and does not masquerade as `sectionCechCofaceMatch`;
  the tilde bridge is openly absent, not papered over. 6 major (all blueprint-side, none blocking):
  the 4 `\lean{}`-named targets absent from the file (expected — unbuilt); the chapter's
  `lem:section_cech_coface_match` block does not decompose into the abstract-unfold step + tilde
  step; the 4 new helpers aren't `\lean{}`-referenced (coverage debt).

## Key patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **`Concrete.productEquiv_apply_apply` won't `rw`/`simp` against section objects**: the argument's
  type is `ToType((sectionCechCosimplicial …).obj (mk p))`, defeq but NOT syntactically
  `ToType(∏ᶜ …)`, so the family metavar `?F` cannot unify. Fix: a named term-mode restatement
  (`sectionCechProductEquiv_apply`) proved by defeq.
- **Heartbeat blow-up from inlining a `homOfLE (le_iInf …)` term into a lemma STATEMENT** (>1M,
  times out even at 4M with a proof). Fix: factor the term into a named `def` (`sectionCechFaceRestr`).
- **`rw [AddCommGrpCat.hom_zsmul]` fails on `ConcreteCategory.hom (n • f)`** (syntactic
  `ConcreteCategory.hom` vs `AddCommGrpCat.Hom.hom`); use
  `simp only [AddCommGrpCat.hom_zsmul, AddMonoidHom.smul_apply]`.
- **`ConcreteCategory.comp_apply` is `rfl` for `Ab`**; use `show … from rfl` (or `change`) to flip
  `hom g (hom f x) ⇄ hom (f ≫ g) x` when `rw [← comp_apply]` fails on the obj-vs-∏ᶜ defeq.

## Blueprint markers updated (manual)
- None this iter. No `\mathlibok` candidates (all 5 new decls are project-proved, not Mathlib
  re-exports). No `\lean{}` rename to apply — the named targets `sectionCechCofaceMatch` /
  `sectionCechAbExact` genuinely don't exist yet (the prover built differently-named *abstract*
  helpers; this is coverage debt for the planner to blueprint, not a rename). No `\notready`
  present on any built block.

## Blueprint doctor
Clean — no orphan chapters, no broken `\ref`/`\uses`, no new axioms. `sync_leanok` ran for iter-21
(sha 408e715; +3 / −5, chapter `Cohomology_CechHigherDirectImage.tex`).

## Recommendations
See `recommendations.md`. Headline: the planner MUST fix the noop-keyword placement for the
FreePresheafComplex lane (keyword on the path's physical line) and re-dispatch the unrun D1
corrective; cover the 5 new `lean_aux` nodes in the blueprint; consider a one-line comment fix for
the overstated `SectionCechBridge` doc.
