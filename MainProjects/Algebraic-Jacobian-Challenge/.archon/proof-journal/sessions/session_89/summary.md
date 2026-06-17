# Session 89 — iter-089 review

## Metadata

- **Archon iteration**: 089
- **Stage**: prover (single substantive prover lane — `Cohomology/BasicOpenCech.lean`).
- **Sorry count before iter-089** (per iter-088 state inherited): 14 syntactic
  sites across the project — 6 in `BasicOpenCech.lean`, 5 in `Differentials.lean`,
  1 in `Modules/Monoidal.lean`, 1 in `Jacobian.lean`, 1 in `Picard/Functor.lean`.
- **Sorry count after iter-089**: **14** total (6 / 5 / 1 / 1 / 1 — same per-file
  distribution). Net **0**. In `BasicOpenCech.lean` the trailing sorry that was at
  L522 has been pushed to **L547**: lines shifted by +25 because the prover added
  the S6 step-(a) `hom_sum_dist` inline `have` (~10 LOC) and the step-(b) `simp
  only [hom_sum_dist]` (1 LOC) along with ~12 lines of brief stepwise comments.
  Current `BasicOpenCech.lean` sorry sites: **L547, L639, L963, L991, L1181,
  L1210** (the iter-088 sites L522/L614/L938/L966/L1156/L1185 all shifted by +25).
- **Compilation status iter-089**: **NOT VERIFIED IN SANDBOX**. The prover and
  this review confirmed `.lake/packages/` contains only `checkdecls` and
  `doc-gen4` — Mathlib is missing — and `lake` is not on PATH
  (`No such file or directory: 'lake'`). `lean_diagnostic_messages` fails at
  startup with the same error documented across iter-086, 087, 088. The
  dispatcher environment is expected to fetch Mathlib and verify the edit.
- **Env state** (from `attempts_raw.jsonl` summary line): 23 total events; **1**
  source `Edit` to `BasicOpenCech.lean` (replacing the trailing `sorry` at L522
  with the step-(a) `have hom_sum_dist` + step-(b) `simp only [hom_sum_dist]` +
  step-(c)–(h) hint comments + trailing `sorry`); **0** `lean_goal` (LSP
  unavailable); **3** `lean_diagnostic_messages` (all returned errors —
  endpoint cannot start in this sandbox); **0** `lean_build`; **0** lemma
  searches by `lean_local_search`/`lean_leansearch`/`lean_loogle`; **2**
  `ToolSearch` (loading deferred-tool schemas).
- **`lean_verify`**: not run this iteration.

---

## Lane summary

| Lane | File | Status | Sorry Δ | Compile |
|---|---|---|---|---|
| 1 | `Cohomology/BasicOpenCech.lean` | **STEPS (a)+(b) LANDED (compilation unverified in sandbox)** — added the inline `have hom_sum_dist` via `Finset.cons_induction` + `ModuleCat.hom_add` (step a), and `simp only [hom_sum_dist]` over both sides (step b). Trailing `sorry` re-located after step (b) at the partially-distributed goal. Steps (c)–(h) explicitly NOT attempted. | 0 (6 → 6) | UNVERIFIED |

---

## Lane 1 — `BasicOpenCech.lean`: S6 steps (a)+(b) landed; (c)–(h) deferred

**Status**: PARTIAL. The iter-089 PROGRESS.md mandated that the prover **must**
attempt S6 in this iteration (correcting the "structure transcribed, closure
not attempted" pattern of iter-087 and iter-088). The PROGRESS.md explicitly
permitted a fallback: *"If S6 cannot be closed, you must at minimum land step
(a) (the inline `hom_sum_dist` `have`) and the `rw [hom_sum_dist]` of step (b),
and put the trailing `sorry` after step (b)"*. The iter-089 prover delivered
exactly that minimum.

### Concrete delivery (single Edit event, lines 522–547 post-edit)

The trailing `sorry` at the post-S5 goal was replaced with:

```lean
  -- S6 step (a) [iter-089]: inline `hom_sum_dist`. `ModuleCat.hom_sum` is
  -- absent from Mathlib (confirmed iter-086); we derive it inline by
  -- `Finset.cons_induction` over `ModuleCat.hom_add`. The Fin index for the
  -- alternating sum is left abstract (`α : Type`) so the result fires under
  -- whichever post-S5 index shape (`Fin (prev n + 2)` raw or `Fin (n+1)` via
  -- `hRel`) the elaborator picks.
  have hom_sum_dist :
      ∀ {M N : ModuleCat.{u} k} {α : Type} (t : Finset α)
        (f : α → (M ⟶ N)),
        ModuleCat.Hom.hom (∑ i ∈ t, f i) = ∑ i ∈ t, ModuleCat.Hom.hom (f i) := by
    intro M N α t f
    induction t using Finset.cons_induction with
    | empty => simp
    | cons h_notin ih =>
      rw [Finset.sum_cons, ModuleCat.hom_add, Finset.sum_cons, ih]
  -- S6 step (b) [iter-089]: distribute `.hom` over the alternating sum on
  -- both LHS and RHS. `simp only` (not `rw`) tolerates HOU pattern variants
  -- between `ConcreteCategory.hom Σ` and `Σ.hom`.
  simp only [hom_sum_dist]
  -- S6 steps (c)–(h) remain for iter-090: (c) distribute `(Pi.π Z₂ j).hom`
  -- over the outer sum via `LinearMap.map_sum`; (d) peel `Pi.lift` via
  -- `Pi.lift_π_apply`; (e) `Pi.smul_apply` for the inner R-action; (f)
  -- `map_mul` to split the restricted-product; (g)
  -- `presheafMap_restrict_collapse` to collapse the algebra-map chain;
  -- (h) `← Finset.smul_sum` to reassemble outer `r •`. See PROGRESS.md iter-089.
  sorry
```

### Why steps (c)–(h) were not attempted inline

The prover task result explicitly considered and **rejected** a
`first | <full (c)–(h) chain> | sorry` wrap on two grounds:
1. Partial progress of any non-trivially-failing attempt would be invisible
   to the next iter (only `sorry` would remain).
2. The iter-090 prover would lose the "deepest committed step" signal that
   the iter-089 PROGRESS.md "Forward Scoping" guidance relies on.

Without LSP feedback, each step (c)–(h) carries a non-trivial dead-end risk
(documented per-step in the prover task result — see `task_results/AlgebraicJacobian_Cohomology_BasicOpenCech.lean.md`).
Committing the safe minimum (a)+(b) preserves the re-scoping signal for
iter-090.

### Attack record (iter-089) — Lane 1

| Event | Tactic / Action | Result | Insight |
|---|---|---|---|
| 5 | `wc -l BasicOpenCech.lean` | `1195` lines | baseline file size pre-edit |
| 9 | `ls .lake/packages/` | `checkdecls\ndoc-gen4` | mathlib package missing (same as iter-086+) |
| 10 | `ls blueprint/src/chapters/` | confirmed `Cohomology_MayerVietoris.tex` is the correct chapter (no `Cohomology_BasicOpenCech.tex`) | matches PROGRESS.md note |
| 11 | `grep cechCofaceMap_pi_smul \| presheafMap_restrict_collapse` in blueprint | confirmed those helpers have no `\lean{...}` macro entries | no blueprint marker work needed |
| 15 | `lean_diagnostic_messages` (relative path) | `Invalid Lean file path` (path resolution failure) | sandbox-LSP path resolution failure mode 1 |
| 16 | `lean_diagnostic_messages` (absolute path) | `Failed to start Lean language server: 'lake' not on PATH` | sandbox-LSP failure mode 2 — confirmed root cause |
| 18 | `Edit` — single replacement at L522: `rw [piIsoPi_hom_ker_subtype_apply, piIsoPi_hom_ker_subtype_apply]\n  sorry` → same `rw` + 25-line block ending in trailing `sorry` | wrote OK | step (a) `have hom_sum_dist` + step (b) `simp only [hom_sum_dist]` + step (c)–(h) hint comments landed |
| 19 | `lean_diagnostic_messages` post-edit | `Failed to start Lean language server` | edit unverifiable in sandbox |
| 22 | `Write` task result | written ✓ | prover delivered the partial-progress report per PROGRESS.md report-shape requirements |

### Adaptation notes from PROGRESS.md template

The PROGRESS.md `hom_sum_dist` template specified:
```lean
have hom_sum_dist :
    ∀ {M N : ModuleCat.{u} k} (s : Finset (Fin ((ComplexShape.up ℕ).prev n + 2)))
      (f : Fin ((ComplexShape.up ℕ).prev n + 2) → (M ⟶ N)),
    ...
```
The prover **generalised** the index type from `Fin ((ComplexShape.up ℕ).prev n + 2)` to an abstract `{α : Type}`. This is a deliberate widening:

- Rationale stated in prover task result: under either the raw `Fin (prev n + 2)`
  shape OR the `Fin (n+1)` shape post-`hRel` rewrite, the elaborator may unify
  with either; an abstract `α` accepts both.
- Risk: if the call-site `simp only [hom_sum_dist]` needs to match a specific
  monomorphic index type, the implicit-argument inference may need a hint. The
  prover marked this as risk #3 ("Universe `α : Type` for the index. The actual
  index in the goal may be `Fin (prev n + 2)` (Type 0). `Type` = `Type 0`
  matches. Risk negligible.")

### Iter-090 Lane 1 path forward (concrete, from prover task result)

Post-(b) goal (expected, unverified):
```
(Pi.π Z₂ j).hom ((eqToHom ∘ₗ (∑ i, .hom of (-1)^i • (Pi.lift … ≫ map_φ_i))
  ) ((piIsoPi Z₁).inv (r • y))) =
  r • (Pi.π Z₂ j).hom ((eqToHom ∘ₗ (∑ i, …)) ((piIsoPi Z₁).inv y))
```

Steps (c)–(h) per PROGRESS.md (each with documented risks):
- (c) `rw [(Pi.π Z₂ j).hom.map_sum]` twice — fallback `simp only [LinearMap.map_sum]`.
- (d) `refine Finset.sum_congr rfl ?_; intro i _; simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply]` — fallback `dsimp only [Pi.lift_π]`.
- (e) `simp only [Pi.smul_apply]` — prefix `letI := perI₁` on failure.
- (f) `rw [map_mul]` (`.hom` of presheaf-map is a `RingHom` via `CommRingCat.Hom.hom`).
- (g) `rw [presheafMap_restrict_collapse _ _ _]` — three `≤`-witnesses left to unification.
- (h) `rw [← Finset.smul_sum]` + `rfl` or `simp only [ConcreteCategory.comp_apply]`.

Estimated ~30–50 LOC after step (b).

### Risks for iter-090 inheriting iter-089's step-(a)/(b) work

Verbatim from prover task result (own-domain expertise):

1. **`hom_sum_dist`'s `induction … using Finset.cons_induction with` case
   labels.** The prover used `| empty => simp | cons h_notin ih => …`. If
   Mathlib's `Finset.cons_induction` uses different case labels (e.g. `h₁`/
   `h₂`), the `with`-block fails. Recovery: replace `induction … with` with
   positional bullets — `induction t using Finset.cons_induction; · simp;
   · intro a t' ha ih; rw [Finset.sum_cons, ModuleCat.hom_add, Finset.sum_cons, ih]`.
2. **`simp only [hom_sum_dist]` firing.** If the goal's sum is wrapped inside
   `eqToHom ∘ₗ Σ.hom` and not directly under a `.hom`-projection subterm
   matchable by the lemma's LHS, `simp only` will be a no-op. Recovery:
   prefix with `unfold Function.comp` or `dsimp only` to reveal the subterm,
   or rewrite via `show` to expose `ModuleCat.Hom.hom (∑ …)` explicitly.
3. **Universe `α : Type` for the index.** The actual index in the goal may
   be `Fin (prev n + 2)` (Type 0). `Type` = `Type 0` matches; risk
   negligible per prover assessment.
4. **`set_option maxHeartbeats 1600000`** at L455 — the inline `have` and
   `simp only` should fit comfortably; if not, iter-090 may need to raise.

---

## Aggregate findings & iter-090 outlook

- **Net sorry count unchanged.** The single `sorry` at the body of
  `cechCofaceMap_pi_smul` (former L522, now L547) was replaced with the S6
  steps (a)+(b) tactics and a trailing `sorry` at the partially-distributed
  goal. `BasicOpenCech.lean` count holds at 6 syntactic sorries; total project
  count holds at 14.
- **Iter-089 process outcome — PROGRESS.md mandate satisfied (minimal level).**
  The PROGRESS.md mandated *"You MUST attempt the S6 chain this iteration"* and
  set a fallback minimum of *"at minimum land step (a) ... and step (b)"*. The
  prover delivered exactly that minimum.  Iter-087 and iter-088 each delivered
  "structure transcribed, closure not attempted" reports; the iter-089 mandate
  to forbid that pattern produced a structurally-positive (if narrow) advance.
- **Iter-089 step (a) generalisation choice (worth noting).** The prover
  generalised `hom_sum_dist`'s index type from `Fin ((ComplexShape.up ℕ).prev n + 2)`
  (PROGRESS.md template) to `{α : Type}`. This is defensible (broader
  applicability under either pre- or post-`hRel` index shape) and was
  documented in the prover task result with a risk assessment. **No false
  signature risk** — the lemma `ModuleCat.Hom.hom (∑ i ∈ t, f i) = ∑ i ∈ t, ModuleCat.Hom.hom (f i)`
  is true for any index type `α` and any `Finset α`. Mathematical-honesty
  audit passes.
- **Realistic iter-090 target.** Net **−1** sorry (5 active in BasicOpenCech,
  13 total) if steps (c)–(h) chain lands cleanly. Path forward is concrete:
  6 well-documented steps with templates and fallbacks already enumerated in
  the prover task result.
- **Iter-090 mandate (matching iter-089's pattern).** The iter-090 plan agent
  should preserve the iter-089 "you MUST attempt steps (c)–(h)" mandate but
  with a finer fallback ladder: if a specific step fails, land all steps
  preceding it cleanly and put the trailing `sorry` immediately after the
  last successful step. The prover task result enumerates each step's
  documented risk catalogue — fold these into the iter-090 PROGRESS.md so
  the prover has the dead-end avoidance list inline.
- **Sandbox issue persists.** `.lake/packages/` still missing `mathlib`;
  `lake` not on PATH. Documented across iter-086, 087, 088, 089. The iter-089
  PROGRESS.md correctly framed this as environmental (not a justification for
  the prover to abstain). The dispatcher environment remains the validation
  point. `TO_USER.md` re-emphasised this iter.

## Blueprint markers updated (manual)

No manual marker changes this iter.

- `cechCofaceMap_pi_smul` and `presheafMap_restrict_collapse` are project-local
  helpers without their own `\lean{...}` entries in
  `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — they are internal
  scaffolding for the main theorem `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
  (chapter L987–991). That main theorem still carries downstream sorries
  (L1181, L1210 in BasicOpenCech.lean), so the deterministic `sync_leanok`
  phase correctly did not add `\leanok` to it. No `\mathlibok` candidates this
  iter (nothing landed as a Mathlib alias). No `\notready` to strip. No
  `\lean{...}` renames (the two top-level helpers were extracted iter-087, not
  this iter).
- The deterministic `sync_leanok` phase ran before this review — its
  `\leanok` placements/removals stand untouched.

## TO_USER status

The sandbox-LSP issue (`.lake/packages/mathlib` missing; `lake` not on PATH)
has now persisted across iter-086, 087, 088, 089. Three consecutive prover
reports (087, 088, 089) have cited this as a structural obstacle. The iter-089
PROGRESS.md framed this as environmental and correctly mandated the prover
attempt S6 regardless — and the prover delivered the minimum-fallback steps
(a)+(b). But the actual validation (compilation, real goal states, real error
messages) still cannot happen in this sandbox. `TO_USER.md` is updated to
re-emphasise the gap.
