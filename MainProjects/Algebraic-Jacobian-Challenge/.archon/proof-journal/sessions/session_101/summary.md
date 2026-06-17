# Session 101 — iter-101 review (project narrative iter-103)

## Metadata

- **Archon iteration**: 101 (= session_101)
- **Project-narrative label**: iter-103 (single substantive prover lane,
  hard-stop close)
- **Iteration shape**: 1 prover lane on
  `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`
- **Sorry count before**: 15 (BasicOpenCech 7, Differentials 5, Monoidal 1,
  Jacobian 1, Picard.Functor 1) — iter-102 (project) close, after
  refactor pair landed the inert `alternating_zsmul_pi_smul_aux_sum_comp`
  helper with `sorry` body.
- **Sorry count after**: **14** (BasicOpenCech 6, Differentials 5,
  Monoidal 1, Jacobian 1, Picard.Functor 1). **BasicOpenCech.lean: 7 → 6**
  — one sorry closed (L590 lemma body, Path B). Hard cap 7 met,
  target 6 met (via Path B not Path A as primary directed).
- **Targets attempted**: (1) `alternating_zsmul_pi_smul_aux_sum_comp`
  body at L590 (Path B); (2) `cechCofaceMap_pi_smul` per-summand `hG`
  discharge — was L802, now L827 sorry (Path A primary).
- **Compile-verified at close**: yes (`lean_diagnostic_messages` returns
  `[]` for severity=error end-to-end). **Ninth consecutive
  compile-verified prover iteration**.
- **Total file events** (per `attempts_raw.jsonl` summary): 74 events;
  11 edits; 3 goal checks; 11 diagnostic checks; 0 builds; 8 lemma
  searches; 7 clean diagnostics; 4 errors observed (3 transient
  during exploration, 1 final-state pre-revert).
- **Prover model**: claude-opus-4-7 (per project metadata).

## Outcome at a glance

**Mixed positive.** Iter-103 closed one sorry via Path B (the
inert-lemma body at L590) and committed two new forward-progress
tactics in the call-site frame (S4 ConcreteCategory→ModuleCat.Hom
pivot, S5 composition decomposition). Path A's primary objective
(close L802 by `show`-pivot def-eq) **failed across 5 distinct
sub-routes**. The sorry at L802 has shifted to L827, with the
post-S5 goal frame now committed and ready for iter-104 escalation.

## Target 1: `alternating_zsmul_pi_smul_aux_sum_comp` (L590) — SOLVED

### Path B body proof (final, committed L590–L609)

```lean
intro r y
rw [Preadditive.sum_comp s (fun i ↦ σ i • G i) E]
simp_rw [Preadditive.zsmul_comp]
exact alternating_sum_pi_smul_aux Z₁ Z₂ s (fun i ↦ σ i • (G i ≫ E)) e₁ e₂
  (fun i hi r y => by
    show e₂ (σ i • (G i ≫ E).hom (e₁.symm (r • y))) =
      r • e₂ (σ i • (G i ≫ E).hom (e₁.symm y))
    rw [map_zsmul e₂ (σ i), map_zsmul e₂ (σ i),
        hG i hi r y, smul_comm (σ i) r])
  r y
```

### Why this works at the binder level

`G` and `E` are quantified as binders (typed variables, not closures).
At this level, `Preadditive.sum_comp` and `Preadditive.zsmul_comp`
match the pattern `(?n • G i) ≫ E` cleanly because `G i` is a
typed-variable application — no anonymous-closure to choke the
discrimination tree.

### Drafting mishap (resolved)

Initial draft used `(e₂ : _ →ₗ[k] _).map_zsmul (σ i) _` which failed
with `Invalid field map_zsmul: The environment does not contain
LinearMap.map_zsmul`. Switching to the free-standing `map_zsmul`
(Mathlib.Algebra.Group.Hom.Defs, AddMonoidHomClass version)
applied through `e₂`'s coercion fired immediately.

**Lemma**: free-standing `map_zsmul` works on any
AddMonoidHomClass; the dot-projected `.map_zsmul` form requires
the projected field to exist on the carrier type (here `LinearMap`).

## Target 2: `cechCofaceMap_pi_smul` per-summand `hG` (L802 → L827) — PARTIAL

### Forward progress committed at L823-L826

```lean
-- iter-103 S4: pivot ConcreteCategory.hom → ModuleCat.Hom.hom.
rw [show (ConcreteCategory.hom : _ → _) = ModuleCat.Hom.hom from rfl]
-- iter-103 S5: decompose ≫ into LinearMap.comp + comp_apply split.
simp only [ModuleCat.hom_comp, LinearMap.comp_apply]
sorry
```

S4 is a constant-level rfl rewrite — always lands (no Pi.lift closure
in head). S5 decomposes the categorical composition into nested
`LinearMap` applications, bringing `(-1)^↑i •` directly onto the
innermost single-morphism `Pi.lift_thing`. **The post-S5 frame is
the cleanest possible form for subsequent extraction** — yet the
discrimination-tree blocker still bites.

### Attempt log for L827 (Path A scalar extraction)

| # | Tactic | Outcome | Insight |
|---|--------|---------|---------|
| 1 | `simp only [ModuleCat.hom_zsmul, LinearMap.smul_apply]` | "no progress" | Discrim tree blocker persists at innermost layer. |
| 2 | body-local `have h_zsmul_apply : ... := fun _ _ => rfl; rw [h_zsmul_apply]` | "no occurrence" / "no progress" | E1 escape (body-local rfl helper) confirmed DEAD — pattern-match runs before rfl-evaluation. |
| 3 | `change` (full Pi.lift literal) for def-eq pivot | `(deterministic) timeout at whnf, 1600000 heartbeats` | Def-eq across Pi.lift fun closure is whnf-prohibitive at 1600000 (and per iter-102 record also at 12800000). |
| 4 | `change` with `_` placeholders | Application type mismatch (eqToHom source ambiguous) | Metavariable elaboration can't pin down without unfolding Z_int. |
| 5 | `rw [← LinearMap.comp_apply, ← ModuleCat.hom_comp]` chain to re-fuse | PARTIAL re-fuse to eqToHom layer, then blocked at smul-prefix layer | Re-fusion works UNTIL (-1)^↑i • appears — same class. |

### Status of Path A

**FAILED**. The discrim-tree blocker for `Pi.lift fun i_1 ↦ ...` is
**definitively confirmed** as resistant to both:
- `rw`/`simp only`-style discrimination (#1, #2, partially #5)
- `show`/`change`-style def-eq checking (#3 whnf timeout, #4 metavar
  ambiguity)

The body-local rfl-helper variant (E1 in earlier plans) confirmed
DEAD again. The structural conclusion: in-place tactic-only routes
cannot extract `(-1)^↑i •` from `((-1)^↑i • Pi.lift fun ...).hom`
in the existing call-site frame.

### Status of Path B at the call site

**Not attempted in iter-103** (only attempted in iter-102, where it
hit 12800000-heartbeat timeout and was reverted). The new lemma
body is now closed (this iteration), so the infrastructure is ready;
but the call-site application's whnf timeout is independent of body
closure. Plan must instruct iter-104 to use Path B with call-site
restructuring (manual `σ := fun i ↦ (-1)^↑i` unfolding, partial
inlining) — or, recommended, escalate directly to Path C.

## Key findings

### What's new in iter-103

1. **`map_zsmul` (free-standing AddMonoidHomClass version) is the
   right form for ZSMul-preservation through `e₂` (LinearEquiv).**
   The dot-projected `.map_zsmul` form is unavailable because
   `LinearMap.map_zsmul` doesn't exist as a projectable field
   (despite the equation holding by rfl).
2. **S4 constant-level rfl pivot
   (`ConcreteCategory.hom → ModuleCat.Hom.hom`) always lands**
   regardless of Pi.lift closure presence, because the rewrite head
   is a constant (no closure in pattern).
3. **S5 `simp only [ModuleCat.hom_comp, LinearMap.comp_apply]`
   composition decomposition lands in the post-S3 frame** and
   brings the smul onto the innermost layer. But the discrim-tree
   blocker survives at that innermost layer too — confirming the
   class is robust to composition decomposition, not just to
   raw `(n • f) ≫ g` patterns.
4. **`change` with `_` placeholders fails the same way `set` with
   `_` codomain fails (iter-100 record).** Lean's elaboration
   cannot pin Pi.lift's anonymous-closure codomain without
   explicit unfolding.
5. **Re-fusing via `← LinearMap.comp_apply` + `← ModuleCat.hom_comp`
   succeeds for non-smul layers but blocks at the smul-prefix layer.**
   Confirms the blocker is at the smul-Pi.lift interface, not at
   the surrounding composition.

### Streak status

This is the **4th consecutive substantive prover lane** on the
`cechCofaceMap_pi_smul` `hG` discharge slot (iter-099 partial,
iter-100 partial, iter-101 partial S1-S3, iter-103 partial S4-S5).
Iter-102 was a refactor pair (added new lemma + reverted call-site
attempt). The streak-escalation criterion that was already triggered
at iter-099 close remains active. Iter-104 **must** escalate to
Path C (top-level R-linear composite helper) — no further raw-tactic
passes on the existing call frame.

## Recommendations for next session

See `recommendations.md`. Headline: refactor lane for Path C
(named-T helper `cechCofaceMap_pi_smul_summand_via_named` per
session_99 § Priority 1), OR Path B with call-site restructuring.

## Blueprint markers updated (manual)

None. The new lemma `alternating_zsmul_pi_smul_aux_sum_comp` is a
project-internal helper without a `\lean{...}` entry in any blueprint
chapter. The closure trajectory does not yet warrant a `\begin{remark}`
block — defer until the call-site consumes the lemma. No `\mathlibok`,
`\notready` removals, or `\lean{...}` renames required (the
deterministic `sync_leanok` phase ran before this review; its
`\leanok` placement is already in the inner-git commit log).
