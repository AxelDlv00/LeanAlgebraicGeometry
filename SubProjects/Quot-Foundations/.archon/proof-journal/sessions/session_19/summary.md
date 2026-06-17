# Session 19 (iter-019) — Review Summary

## Metadata
- **Iteration / session**: iter-019 / session_19
- **Build**: GREEN — all 3 modified modules `lake build` EXIT 0 (only expected `sorry` + style/heartbeat
  warnings); blueprint-doctor clean (0 orphan chapters, 0 broken refs, 0 axioms).
- **Sorry deltas (this iter)**: FBC 4→4 · GF 3→3 · QUOT 4→5 (**net +1**, the QUOT base-case leaf).
- **New axiom-clean declarations**: **+18** (1 GF helper + 17 QUOT), all re-verified
  `{propext, Classical.choice, Quot.sound}` (independently re-run on the keystone + the 2 FBC sub-lemmas
  + the GF helper this review).
- **Lanes dispatched**: 3 (FBC fine-grained, GF prove, QUOT prove).
- **Headline**: low closure count, but **two genuine multi-iter blockers broke** via the exact
  correctives the planner staged (both flagged STUCK by the progress-critic):
  - **QUOT** finiteness-transfer keystone `subquotient_finite_transfer` (3-iter blocker) — RESOLVED
    axiom-clean, and the **entire Stacks 00K1 ambient subquotient induction**
    `gradedModule_hilbertSeries_rational` (the SNAP-S2 keystone) is assembled end-to-end with **exactly
    one** residual leaf (base-case `iSupIndep`).
  - **GF** L4 injectivity crux (5-iter stuck) — RESOLVED inside
    `exists_localizationAway_finite_mvPolynomial`; only the module-finiteness conjunct remains.
  - **FBC**: 2/5 step-(iii) atomic sub-lemmas closed axiom-clean; the assembly stays blocked on the
    documented post-`subst` leg-lock (6th consecutive iter the assembly goal is unmoved).

No deception found: every `sorry` is honest scaffolding with an accurate roadmap comment, no fake/weakened
statements, no `axiom`s (lean-auditor: 0 must-fix / 0 major).

---

## FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (4→4)

**Objective**: STUCK corrective — effort-break the step-(iii) mate-unwinding crux of
`base_change_mate_fstar_reindex_legs` into 5 standalone atomic lemmas (whole-goal attempts PROHIBITED),
prove bottom-up. Partial-success bar: `_unitExpand` + `_gammaDistribute` + `_eCancel`.

**Result**: 2/5 closed (`_unitExpand`, `_gammaDistribute`), both axiom-clean and abstract/reusable
(general schemes / general functor `F`). The assembly `sorry` is unchanged; `_eCancel`/`_affineUnit`/
`_innerMatch` could not even be **stated** — their types only materialise after a goal state the leg-lock
prevents reaching cleanly.

### Key technical finding — spurious `X.Modules` instance diamond
The pervasive obstacle this pass: under single-file/LSP elaboration a spurious `X.Modules` instance
diamond defeats **tactic-mode** `rw [Category.assoc]`, `rw/simp [Functor.map_comp]`,
`rw [Iso.inv_hom_id_app]`, and even `rw [hI]` with a freshly-elaborated identical `hI` — all fail to
match. The **same** steps succeed in **term mode** (`congrArg`, `.trans`, `Category.assoc`/`F.map_comp`
as terms, `exact`) because elaboration unifies the instances up to defeq.
- `_unitExpand`: `rw [pullbackPushforward_unit_comp a b N]` then close the trailing
  `(a≫b)_*(pullbackComp.inv ≫ pullbackComp.hom) = 𝟙` cancellation in term mode
  (`(congrArg (η ≫ ·) hI).trans (Category.comp_id _)` + `Category.assoc` as a term).
- `_gammaDistribute`: after `unitExpand`, distribute an arbitrary functor `F` over the 4-factor
  composite via `(F.map_comp _ _).trans (congrArg … (F.map_comp _ _))` (three threaded `map_comp`s).

### The genuine blocker (leg-lock) — unchanged
Wiring `unitExpand` into the assembly fails at the **matching** stage: after `subst hfst/hsnd` the leg
`(pullbackSpecIso …).hom ≫ Spec.map (CommRingCat.ofHom …)` is locked literally and will not unify with
the metavariable composite `?a ≫ ?b` of `(pullbackPushforwardAdjunction (?a ≫ ?b)).unit.app ?N`. **6th
consecutive iter (014–019) the assembly goal is unmoved.** The prover's recommended route forward is a
**refactor** (rewrite the `g'`-unit via a `g'`-parametrised lemma BEFORE `subst`, so `g'` is still a free
local and matches), then state+prove the remaining 3 sub-lemmas inline — **not** another standalone
fine-grained helper round.

---

## GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean` (3→3)

**Objective**: close L4 `exists_localizationAway_finite_mvPolynomial`.

**Result**: the **injectivity crux — stuck 5+ iters — is now FULLY PROVEN.** Witness `g := g0` (F3 common
denominator). Built: `algAgBg`, comparison maps `ν : B_g →+* B_K` and `ψ : A_g →+* K` (`IsLocalization.lift`,
both proven injective via the new helper `isLocalization_lift_injective` + `IsLocalization.injective`),
generators `b_j` with `ν(b_j) = gK(X_j)`, `φ := aeval b`, the compatibility square `hsquare`
(`IsLocalization.ringHom_ext (powers g0)` reducing to `A`-level), and `Function.Injective φ` via
`ν ∘ φ = gK ∘ (map ψ)` (a composite of injectives, `Function.Injective.of_comp`). The **only** remaining
`sorry` (line 754) is the module-finiteness conjunct.

- **Heartbeats**: `synthInstance.maxHeartbeats 1000000` + `maxHeartbeats 4000000` are required (nested
  `Away` localisations make instance search deep; mirrors `gf_torsion_reindex`). lean-auditor: legitimate.
- **`b`-vs-`φ` defeq**: `set φ … with hφ_def` then `simp [hφ_def, aeval_X]` (NOT `change`, which fails the
  `ν (b j)` vs `ν (φ (X j))` defeq check).
- **Finiteness leaf**: must refine the witness to `g := g0 * g1` (`g1 ≠ 0` clearing the `K[X]`-coefficients
  of the monic integral-dependence equations of the generators `σ`), then
  `Algebra.finite_adjoin_of_finite_of_isIntegral` [verified present]. All injectivity scaffolding transfers
  verbatim to `g0*g1`. **Negative**: Mathlib has NO generic-fibre→basic-open finiteness descent
  (`Module.Finite.of_localizationSpan*` are local→global, wrong direction) — the per-generator
  integral-clearing (Nitsure) is required, no shortcut.

---

## QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean` (4→5, +17 axiom-clean)

**Objective** (planner decision, rebutting the critic's protected-stub metric): top-down induction-body
drafting in `prove` mode (sorries allowed); success bar = close the keystone
`gradedModule_hilbertSeries_rational` (SNAP-S2), NOT a protected-stub closure (the 4 stubs sit several
SNAP phases downstream).

**Result — success bar MET.** The entire Stacks 00K1 ambient subquotient induction is assembled
end-to-end:
- **`subquotient_finite_transfer`** (the genuine 3-iter blocker) — RESOLVED axiom-clean. σ-semilinear
  transfer along `lastVarAlgHom` (`X last ↦ 0`, `X castSucc i ↦ X i`); the mod-`P'` semilinearity heart
  `polyEndHom_lastVar_sub_mem` is proved by `MvPolynomial.induction_on` (X_last case → `P'` by
  annihilation; X_castSucc case = IH), then `Module.Finite.of_surjective` with the identity σ-semilinear
  map on the **defeq** quotient carriers (`Submodule.liftQ`).
- **`SubquotientDatum.ker` / `.coker`** constructors — fully proved (`hfin` via
  `subquotient_finite_transfer` fed by `polyQuot_finite_of_le_numerator`/`_of_le_denominator`).
- **`subquotient_hilbertSeries_rational`** (induction on `r`) and the top-level
  **`gradedModule_hilbertSeries_rational`** (builds the `(⊤,⊥)` datum, runs the induction, collapses
  `subquotientHilb ⊤ ⊥ = (n ↦ dim_κ ℳ n)` via `top_inf_eq`/`bot_inf_eq`/`finrank_bot`) — fully assembled.
  No `isDefEq`/`whnf` runaway fired (continues to validate Route 2).

**The single residual `sorry`** (line 1494, `subquotient_base_eventuallyZero`): `iSupIndep` of the
degreewise images `range (ψ n)` in the finite-dimensional base quotient `Q`. Everything else in the base
case is proved. The math is settled (degree-`n` projection detector + homogeneity of `N'` = `D.hN'`); the
obstruction is purely scalar-ring plumbing — building the κ-linear detector `Φ` **out of** the
`MvPolynomial (Fin 0) κ`-quotient `Q` via `Submodule.liftQ` clashes on the scalar ring. Recommended route
(b): dfinsupp destructuring of `⨆ j≠n` (`Submodule.mem_iSup_iff_exists_dfinsupp`) + the degree-`n`
homogeneous component directly, staying inside `Q`'s fixed κ-structure (no outgoing map).
`Submodule.finite_ne_bot_of_iSupIndep` [verified] finishes once it lands.

---

## Key findings / patterns
- **Term-mode escape from the `X.Modules` instance diamond** (FBC): when `rw`/`simp` on
  composition/functoriality/iso-cancellation steps "make no progress" or "fail to find pattern" despite a
  literally-present subterm, switch to term-mode combinators (`congrArg`/`.trans`/`F.map_comp` as terms);
  they check the same equality up to defeq and tolerate the diamond.
- **σ-semilinear `Module.Finite` transfer on defeq quotient carriers** (QUOT): when two quotient carriers
  are defeq (same underlying submodule), the transfer map is the identity on elements and σ-semilinear by
  a `liftQ` whose `map_smul'` is discharged by an `induction_on` lemma — then `Module.Finite.of_surjective`.
- **`IsLocalization.lift` injectivity helper** (GF): `isLocalization_lift_injective` —
  `rw [IsLocalization.lift_injective_iff]` after annotating the codomain `(… : S →+* P)` (else the
  instance is stuck on metavariables).

## Subagent reports (all returned; reports in `.archon/task_results/`, archived to `logs/iter-019/`)
- **lean-auditor `iter019`** — PASS, **0 must-fix / 0 major / 4 minor**. Confirms all sorries honest, the
  2 FBC term-mode lemmas sound (no hidden gap), all heartbeat bumps legitimate, exactly one residual hole
  in the QUOT chain (`iSupIndep`), no axioms/fake statements. Minors: stale internal iter-numbers in FBC
  & QUOT docstrings (234/236/240/241, 177); one mildly inflated FBC heartbeat bump on a sorry-bearing
  theorem (line 1323).
- **lean-vs-blueprint-checker `fbc-iter019`** — blueprint **ADEQUATE** ("sufficiently detailed to guide
  formalization; no blueprint adequacy failures"). The 4 "must-fix" rows are the open sorries themselves
  (downstream-blocking), not chapter defects.
- **lean-vs-blueprint-checker `gf-iter019`** — L4 blueprint **ADEQUATE** (sorry is a proof residue, not a
  gap). MAJOR: **11 `private` Lean decls carry public `\lean{…}` pins** → `sync_leanok` cannot see them,
  dashboard under-reports 11 proved axiom-clean decls. MINOR: `isLocalization_lift_injective` needs a block.
- **lean-vs-blueprint-checker `quot-iter019`** — induction infrastructure fully formalized & sorry-free.
  **1 must-fix**: `Grassmannian.representable` (protected stub) has a **weakened signature** vs the full
  representability claim (already flagged by the chapter's own `% NOTE:`). 5 blocked-missing pins
  (`sectionGraded*`, `hilbertPolynomialOfSectionModule` — tensor-product-of-sheaves gap, registered).
  MAJOR: the `iSupIndep` leaf; loose signatures on `hilbertPolynomial`/`QuotFunctor` (missing proper-support
  hypothesis, to add when bodies land).

## Coverage debt
`archon dag-query unmatched` → **18 unmatched `lean_aux` nodes** (1 GF + 17 QUOT). Listed in
`recommendations.md` for the planner to blueprint. 17 are proved/axiom-clean; 1 carries the residual sorry
(`subquotient_base_eventuallyZero`). `archon dag-query gaps` → **0 ∞-holes**.

## Blueprint markers updated (manual)
- **None this iter.** No Mathlib re-exports among the new decls (no `\mathlibok`); the
  `subquotient_finite_transfer` pin already names the renamed-from-`_core` decl correctly (no `\lean{}`
  correction needed); no stale `\notready` present. The GF private-pin mismatch and the
  `Grassmannian.representable` signature debt are planner-domain (de-`private` refactor / blueprint prose),
  recorded in `recommendations.md` rather than papered with markers.

## Low-severity notes (lean-auditor minors)
- Stale internal iter-numbers in FBC (`FlatBaseChange.lean:184–247`, `1369–1421`) and QUOT
  (`QuotScheme.lean:119–124`) docstrings — cosmetic; prune when the relevant sorry closes (review cannot
  edit `.lean`).
- `FlatBaseChange.lean:1323` `maxHeartbeats 1600000` on a sorry-bearing theorem — mildly inflated, no loop;
  recommend confirming the bump is needed for the pre-sorry prefix when next touched.
