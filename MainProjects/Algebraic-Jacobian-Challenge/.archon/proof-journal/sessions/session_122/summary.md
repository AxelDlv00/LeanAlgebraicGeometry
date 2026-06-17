# Session 122 — Review (iter-122)

## Metadata

- **Iteration**: 122 (review of iter-122)
- **Stage**: prover (Iter-122 is the first M1-route prover lane after
  the iter-121 strategic pivot. Per the iter-121 user directive in
  `USER_HINTS.md` — "act as a Mathlib contributor; fill the gap by
  writing it; no deferred tasks" — the project operates as a
  Mathlib contributor; M1 is the bridge milestone
  `relativeDifferentialsPresheaf_equiv_kaehler_appLE`.)
- **Sorry count entering iter-122 plan phase**: **1** (`Jacobian.lean:179`
  `nonempty_jacobianWitness` only — the iter-120 close left the
  project in its previous "ship with one inline sorry" end-state).
- **Sorry count after iter-122 plan-phase refactor**
  (`m1-bridge-iter122`): **5** (intentional milestone-opening:
  4 new sorry sites introduced on `Differentials.lean` by the
  refactor — L109 algebra-instance letI, L112 `appLE_isLocalization`
  body, L142 module-instance letI, L145 bridge body — plus the
  existing `Jacobian.lean:179`).
- **Sorry count after iter-122 prover lane**: **2** (`Differentials.lean:304`
  `appLE_isLocalization` body M1.b — Steps 1–4 still TODO; plus the
  existing `Jacobian.lean:179` `nonempty_jacobianWitness`).
  Net for the iter (refactor + prover combined): **1 → 2** (one new
  sorry introduced and not closed — the M1.b body which the iter-122
  plan explicitly framed as "PARTIAL is the realistic iter-122
  outcome"; estimated 100–250 remaining LOC).
- **Targets attempted**: 1 (`AlgebraicJacobian/Differentials.lean`
  — the M1 bridge scaffolding introduced by the plan-phase refactor).
- **Targets resolved (full closure)**: 3 of 4 introduced sorry sites
  (L109 algebra-instance letI, L142 module-instance letI, L145 bridge
  body M1.e) plus 1 additional sub-claim closure (`isUnit_appLE_unitSubmonoid_in_colim`,
  the Step 0 lemma; ~70 LOC of helper).
- **Targets PARTIAL**: 1 (`appLE_isLocalization`; Step 0 closed,
  Steps 1–4 remain).
- **New axioms introduced**: none.
- **Compile status**: project compiles. `lake env lean
  AlgebraicJacobian/Differentials.lean` returns only the documented
  `sorry` warning at L304 (`appLE_isLocalization` body). `lake build`
  end-to-end succeeds; only sorry warnings reported are L304 in
  Differentials and L179 in Jacobian (`nonempty_jacobianWitness`).
- **Protected signatures touched**: none. `archon-protected.yaml`
  unchanged (9 protected declarations at original paths with
  unchanged signatures). The introduced declarations
  (`appLE_unitSubmonoid`, `appLE_colimRingHom`, `appLE_colimAlgebra`,
  `appLE_colimRingHom_comp_φV`, `isUnit_appLE_unitSubmonoid_in_colim`,
  `appLE_isLocalization`, `kaehler_localization_subsingleton`,
  `kaehler_quotient_localization_iso`,
  `relativeDifferentialsPresheaf_equiv_kaehler_appLE`) are all
  non-protected leaf decls.
- **Pre-processed events**: 256 total events in
  `proof-journal/current_session/attempts_raw.jsonl` — 53 edits,
  23 diagnostic checks, 2 goal checks, 12 lemma searches, 19 total
  errors recorded across attempts, on a single file
  (`AlgebraicJacobian/Differentials.lean`).
- **Prover-phase shape**: a single substantive prover stream on
  `Differentials.lean`, complemented by a deep-prover subagent
  dispatch (`archon-lean4:lean4-sorry-filler-deep`) that closed L109
  (the algebra-instance letI) by lifting it out of an inline
  `sorry`-ed `letI` into a top-level `noncomputable def
  appLE_colimAlgebra`.
- **Meta**: `meta.json planValidate.status: ok / objectives: 1`;
  PARTIAL outcome on the single objective (Differentials.lean).

## Per-target detail

### Target: `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` (M1.b) — PARTIAL

**Status**: **partial**. Step 0 of the four-step `IsLocalization.of_le`
chain is closed via the new helper lemma
`isUnit_appLE_unitSubmonoid_in_colim` (L164, ~70 LOC). Steps 1–4
remain as the single residual sorry at L304.

**Net file change**: 4 introduced sorry sites → 1 remaining. The
three sorry sites that were closed this iter are L109 (algebra
instance via `appLE_colimAlgebra` def), L142 (module instance via
`inferInstanceAs` from the underlying `ModuleCat`), and L145
(bridge body via the M1.d tower-cancellation `LinearEquiv`).

#### Attempt path (chronological; ~53 edits, ~23 diagnostic checks)

1. **L142 module-instance closure** (Edit at L142): replaced
   `letI : Module Γ(X, V) ((relativeDifferentialsPresheaf f).presheaf.obj (.op V)) := sorry`
   with `inferInstanceAs (Module Γ(X, V) (((relativeDifferentialsPresheaf f).obj (.op V)) : Type _))`.
   The `PresheafOfModules` structure provides the module instance on the
   underlying `ModuleCat`; this is a direct transport-of-instance. Build
   confirms `0` errors after this edit (L109/L112/L145 sorries still
   present). **Result: SUCCESS** (first probe).

2. **L109/L112 split via top-level `appLE_colimRingHom` def**: the
   deep-prover subagent introduced a top-level `noncomputable def
   appLE_colimRingHom (f : X ⟶ S) {U V} (e : V ≤ f ⁻¹ᵁ U) : Γ(S, U) ⟶ A_colim`
   as the composition `(adj.unit.app S.presheaf).app (op U) ≫
   ((pullback _ _).obj S.presheaf).map (homOfLE e).op` (L97–L102), and a
   companion `@[reducible] noncomputable def appLE_colimAlgebra` that
   provides the algebra structure as `(appLE_colimRingHom f e).hom.toAlgebra`.
   The body of `appLE_isLocalization` was refactored to use this
   algebra instance via `letI : Algebra Γ(S, U) Acolim := appLE_colimAlgebra f e`
   (replacing the inline `sorry`-ed `letI`). One LSP warning
   ("Definition of class type must be marked with `@[reducible]`")
   was triggered; the fix was already in the writer's pattern
   (`@[reducible]`). **Result: SUCCESS** — L109 sorry eliminated.

3. **Factorisation theorem `appLE_colimRingHom_comp_φV`** (L116–L150,
   ~35 LOC of category-theory manipulation): the prover wrote the
   triangle identity
   `appLE_colimRingHom f e ≫ φV = Scheme.Hom.appLE f U V e`
   where `φV` is `(homEquiv).symm f.c .app (op V)`. The proof
   strategy is the standard unit triangle + naturality combo:
   set `φ' := (adj.homEquiv).symm f.c`, derive
   `htri : adj.unit.app S.presheaf ≫ (pushforward _).map φ' = f.c`
   from `(adj.homEquiv _ _).apply_symm_apply f.c`; specialise at
   `op U` to get
   `htriU : (adj.unit.app S.presheaf).app (op U) ≫ φ'.app (op (f ⁻¹ᵁ U)) = Scheme.Hom.app f U`;
   combine with `φ'.naturality (homOfLE e).op` via a 3-step `calc`
   that swaps the unit-naturality `≫` and reassociates. The proof
   required ~6 attempts to land:
   - early attempts via `rw [show ... from ...]` failed because
     the `((pullback ⋙ pushforward).obj S.presheaf)` rewrite target
     does not pattern-match against `(((pullback _).obj S.presheaf).obj _)`
     under the rewriter's type-equality elaboration (functor-composition
     defeq blocker);
   - the calc-block approach succeeded by sequencing the rewrites
     into explicit `=` steps that each unify pointwise rather than
     leaning on `rw`'s pattern-match. **Result: SUCCESS** (after iteration).

4. **L145 bridge body M1.e closure** (single Edit): the body of
   `relativeDifferentialsPresheaf_equiv_kaehler_appLE` is closed by:
   - `letI algSU_colim := appLE_colimAlgebra f e` (the cocone leg
     algebra),
   - `haveI hLoc := appLE_isLocalization f hU hV e` (the M1.b
     hypothesis — used as a black box since the body is still open),
   - `letI algColim_B := φV.hom.toAlgebra` (the upper Algebra layer),
   - `letI algSU_B := (Scheme.Hom.appLE f U V e).hom.toAlgebra` (the
     overall appLE Algebra layer),
   - `haveI hTower : IsScalarTower Γ(S, U) Acolim Γ(X, V) := IsScalarTower.of_algebraMap_eq' <| by ...`
     via the factorisation `appLE_colimRingHom_comp_φV`,
   - `exact (kaehler_quotient_localization_iso _).symm` (the M1.d
     `LinearEquiv`).
   This packaging closes the M1.e bridge body modulo M1.b — the
   `IsLocalization` hypothesis is invoked by name; the bridge is
   structurally complete and will become fully `\leanok`-able as
   soon as `appLE_isLocalization` closes. **Result: SUCCESS** (first
   probe via the new helper chain).

5. **Step 0 lemma `isUnit_appLE_unitSubmonoid_in_colim`** (L164–L267,
   ~70 LOC) — the iter's hardest piece of work. The goal is to show
   that each `g ∈ appLE_unitSubmonoid f hU hV e` is a unit in `A_colim`
   under the `appLE_colimAlgebra` algebra map. Strategy
   (5-substep, all closed):
   - **(a)** From `hg : IsUnit ((Scheme.Hom.appLE f U V e).hom g)` derive
     `hVle : V ≤ f ⁻¹ᵁ S.basicOpen g` using `Scheme.basicOpen_of_isUnit`
     + `Scheme.basicOpen_appLE` (which says
     `X.basicOpen ((f.appLE V U e).hom s) = V ⊓ f ⁻¹ᵁ (S.basicOpen s)`).
   - **(b)** Build the cocone leg `cleg : Γ(S, S.basicOpen g) ⟶ Acolim`
     as `(adj.unit.app S.presheaf).app (op (S.basicOpen g)) ≫ Pf.map
     (homOfLE hVle).op` (the "pre-image-presheaf restriction at the
     `S.basicOpen g` index"), and the restriction
     `rstr : Γ(S, U) ⟶ Γ(S, S.basicOpen g)` as `S.presheaf.map (homOfLE
     (S.basicOpen_le g)).op`.
   - **(c)** Prove `hcompat : appLE_colimRingHom f e = rstr ≫ cleg`.
     This is the "naturality + functoriality" identity. Proof: factor
     `homOfLE e = homOfLE (f.preimage_le_of_le (S.basicOpen_le g)) ≫
     homOfLE hVle` as ops in `(Opens X)ᵒᵖ`, apply `Pf.map_comp` (where
     `Pf := (pullback _ _).obj S.presheaf`), then commute the unit
     restriction via naturality of `adj.unit.app S.presheaf` at
     `homOfLE (S.basicOpen_le g)`. **This step took ~15 edit attempts**
     because `rw [Functor.map_comp]` failed pervasively on
     `((pullback _ _).obj S.presheaf).map (f ≫ g)` despite the pattern
     being printed in the failure message. Diagnosis from
     `lean_diagnostic_messages`: pattern-match runs before defeq
     elaboration, and the `Lan`-defined functor instance carries
     category metadata that doesn't unify under the rewriter.
     **Workaround**: pre-prove `hmc : Pf.map (f ≫ g) = Pf.map f ≫ Pf.map g`
     as a `have ... := Functor.map_comp _ _ _`, then `erw [hmc]`
     (`erw` succeeds where `rw` fails). Final form at L208–L247.
   - **(d)** Use `IsAffineOpen.isLocalization_basicOpen hU g` to get
     `IsLocalization.Away g Γ(S, S.basicOpen g)`, then
     `IsLocalization.Away.algebraMap_isUnit g` gives
     `h_unit_rest : IsUnit ((algebraMap Γ(S, U) Γ(S, S.basicOpen g)) g)`.
     Used `h_alg_rest : (algebraMap _ _) = rstr.hom := rfl` to convert
     to ring-hom form for the next step.
   - **(e)** Push through the cocone leg: define
     `h_factor : (appLE_colimRingHom f e).hom g = cleg.hom (rstr.hom g)`
     via `rw [hcompat, CommRingCat.hom_comp]; rfl`, then conclude
     `IsUnit ((appLE_colimRingHom f e).hom g)` by `rw [h_factor]; exact
     h_unit_rest.map cleg.hom`. The final step then exploits the
     definitional equality `(algebraMap Γ(S, U) Acolim) = (appLE_colimRingHom f e).hom`
     (from `appLE_colimAlgebra := φ.hom.toAlgebra`) to `exact h_unit_colim`.
     **Critical lesson**: `change`/`show` on `algebraMap` failed
     directly (`'change' tactic failed, pattern ... is not definitionally
     equal to target`) — `Lean's elaboration of IsUnit and the algebra
     instance aligns when the term is exact-ed rather than change-d`.
     Workaround: route the conclusion through `IsUnit ((appLE_colimRingHom f e).hom g)`
     first via the `h_factor` hypothesis, then close via `exact`.

   **Result: SUCCESS** — Step 0 closure landed at L267, ~70 LOC.

6. **L304 `appLE_isLocalization` body — Steps 1–4 NOT attempted this iter.**
   The body remains a single `sorry` at L304. The plan-phase
   PROGRESS.md framed PARTIAL as the realistic outcome, so this
   matches expectations. Estimated remaining LOC: 100–250 (per the
   `task_results/Differentials.lean.md` analysis).

## Key findings / proof patterns discovered this session

1. **`rw [Functor.map_comp]` fails on `((TopCat.Presheaf.pullback _ _).obj _).map (f ≫ g)`**
   despite the pattern being literally present in the goal. Diagnosis:
   the `Lan`-defined functor instance carries category-instance
   metadata that the rewriter's unification doesn't see through.
   **Workaround**: pre-prove `hmc : Pf.map (f ≫ g) = Pf.map f ≫ Pf.map g`
   as a `have ... := Functor.map_comp _ _ _`, then `erw [hmc]`.

2. **`rw [Category.assoc]` similarly fails** in goals involving the
   left-Kan-extended functor. **Workaround**: `exact Category.assoc _ _ _`
   directly when the goal is exactly the associativity equation.

3. **`change`/`show` on `algebraMap g` doesn't unify** even when the
   algebra is `φ.hom.toAlgebra` (which should make
   `algebraMap = φ.hom` definitionally). **Workaround**: route the
   conclusion through `IsUnit ((appLE_colimRingHom f e).hom g)` first
   via a `have h_factor`, then `exact` the result.

4. **`adj.unit.naturality` produces an equation involving the identity
   functor** `((𝟭 _).obj _)`. **Workaround**: `simpa using
   ((adj.unit.app S.presheaf)).naturality _` cleans it up.

5. **Pattern for "directed colim of localizations is localization at
   union submonoid"**: build it as `IsLocalization` via
   `IsLocalization.of_le`, not as a Mathlib `Functor.Final` colim
   comparison (already a Knowledge Base pattern entry from iter-121;
   reconfirmed this iter that Step 0 was the right initial step).

## Recommendations for next session

(Full list in `recommendations.md`. Top-priority items:
**CRITICAL #1** — iter-123 prover lane continues on `Differentials.lean:304`
to land Steps 1–4 of `IsLocalization.of_le`, with Step 0 closure available
as `isUnit_appLE_unitSubmonoid_in_colim`. **CRITICAL #2** — Lean docstring
at `Differentials.lean:436–447` (`smooth_locally_free_omega` block) still
claims the bridge is "out of autonomous-loop scope"; this is now stale
since the bridge is being actively formalized — plan agent should dispatch
a refactor to clean up that docstring.)

## Blueprint markers updated (manual)

None this iter.

Rationale:
- `\leanok` is sync_leanok-managed; the deterministic phase will handle
  `\leanok` adds/removals on
  `lem:kaehler_localization_subsingleton` (fully proved this iter),
  `lem:kaehler_quotient_localization_iso` (fully proved this iter),
  and (for the proof block) `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE`
  (transitively sorry-bearing through `appLE_isLocalization`, so the
  proof block will NOT receive `\leanok` automatically — this is
  correct: the proof body invokes `appLE_isLocalization` by name).
- No `\mathlibok` candidates: all new project-side declarations are
  genuine project proofs (not direct Mathlib re-exports), even the
  thin re-export `kaehler_localization_subsingleton` (which composes
  two Mathlib pieces with a `letI` — close enough to a re-export
  but the project explicitly wants it as a named lemma per blueprint
  `lem:kaehler_localization_subsingleton`).
- No `\notready` to strip; no chapter had one entering this iter.
- No `\lean{...}` renames: the prover used exactly the names the plan
  agent provided in PROGRESS.md (`appLE_isLocalization`,
  `relativeDifferentialsPresheaf_equiv_kaehler_appLE`,
  `kaehler_localization_subsingleton`,
  `kaehler_quotient_localization_iso`).
- `% NOTE:` annotations: not warranted this iter (no chapter has a
  failed-translation block requiring a `% NOTE:` explanation).

## Notes (LOW-severity / informational)

- `lake build` end-to-end timing: ~3 minutes (prover-phase final
  build). 8323 of 8328 jobs replayed; the only modified target was
  `AlgebraicJacobian.Differentials`. Compile-warning surface
  reduced compared with iter-119 (whose ~45 LOC structured-cascade
  body landed at line 101 and triggered a line-length warning).
  This iter's `algebraize [...]` call from iter-120 is unchanged
  and remains the only line-length warning in the file (at the
  closing of `smooth_locally_free_omega`).

- Prover engaged the `archon-lean4:lean4-sorry-filler-deep` subagent
  (visible in the `Agent` event at log line 67) to break the
  inline algebra-instance `letI sorry` out into the top-level
  `appLE_colimAlgebra` def — a cleaner architectural choice than
  closing the inline `letI` directly (the latter would require
  re-proving the algebra-instance contents inside every consumer's
  scope). This is consistent with the iter-121 mathlib-analogist's
  recommendation to use a top-level `IsAffineOpen.appLE_colimAlgebra`
  rather than inline letIs.

- The factorisation theorem `appLE_colimRingHom_comp_φV` (L116)
  IS reusable for the iter-123 Step 1 (`IsLocalization.lift` for
  `A_M → A_colim` — once `g ∈ M` is a unit in `Γ(X, V)` and
  factors through `A_colim` via the cocone leg, the universal map
  out of `Localization M` lands as `appLE_colimRingHom f e`,
  which by this factorisation lemma composed with `φV` is
  `Scheme.Hom.appLE f U V e`) and Step 3 (composite-identity
  verification via `IsLocalization.ringHom_ext`).
