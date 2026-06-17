# Recommendations for the next plan-agent iteration (iter-093)

## TL;DR

Iter-092 was the first compile-verified iteration since iter-085. The
prover (a) **resolved the six-iteration sandbox-LSP environmental gap**
by symlinking `~/.elan/bin/{lake,lean,...}` into `~/.local/bin/`,
(b) **surfaced two foundational compile bugs** in the iter-091 bare
chain commit (doc-comment vs `set_option in` ordering at L454; 12-name
`intro` over zeta-reduced `letI` at L495) and fixed them, (c)
**retracted iter-086+'s "ModuleCat.hom_sum absent from Mathlib" misclaim
** by binding the lemma with explicit `(R := k)`, and (d) **landed step
(a) of the S6 chain on this cleaner footing**. The iter-091 chain at
L559–L583 (d-body+e+f+g+closure) was **removed** because step (b)
`simp only [hom_sum_dist]` is HOU-blocked. File compiles with **6
sorries** (hard cap respected). Project total: **14** sorries (back to
iter-090 baseline, but compile-verified).

Iter-093's job is straightforward: **solve step (b)** via one of three
documented routes, then re-attempt the iter-091 chain with per-step
LSP validation.

## Critical retractions to propagate into PROGRESS.md / STRATEGY.md / Knowledge Base

1. **`ModuleCat.hom_sum` IS in Mathlib** at
   `Mathlib/Algebra/Category/ModuleCat/{Semi,Basic}.lean` (visible to
   `lean_local_search`). The "Known Blocker" entry calling it "absent
   from Mathlib" (carried since iter-086) is **WRONG**. Strike it from
   PROGRESS.md and PROJECT_STATUS.md. The actual blocker is HOU pattern
   matching on the specific Čech-differential summand shape, not lemma
   absence.

2. **The six-iteration "sandbox-LSP unavailable" condition is RESOLVED**.
   The prover symlinked `~/.elan/bin/lake` (and friends) into
   `~/.local/bin/`, which is on `$PATH`. Subsequent provers can rely on
   `lake build` and `lean_diagnostic_messages` returning real results.
   The "compilation unverified in sandbox" caveat that has been on
   every iter-086–091 PROGRESS.md / PROJECT_STATUS.md / TO_USER.md
   should be removed. The mandate-with-per-step-fallback-ladder pattern
   no longer needs the "no-LSP" framing.

3. **The iter-091 review's claim of "13 sorries" was a syntactic
   mirage**. The file did not compile end-to-end; iter-092's
   `lake build` surfaced two compile errors in the iter-091 bare chain
   that the missing LSP could not catch. The actual compile-verified
   sorry count at the iter-090 baseline was 14, and iter-092 returns
   to 14. **PROJECT_STATUS.md must record "14" not "13"**.

## Priority targets for iter-093

### 1. `cechCofaceMap_pi_smul` step (b) — Lane 1 primary

**Status going in**: foundation repaired, step (a) `hom_sum_dist`
bound to Mathlib lemma with explicit `(R := k)` at L551–L555, single
sorry at L570 documenting the HOU obstruction.

**Three routes to try (the prover documented all three)**:

#### Route 1: skip `hom_sum`, distribute via `LinearMap.sum_apply`

Open the `∘ₗ` composition first via `LinearMap.coe_comp` and convert
the outer `ModuleCat.Hom.hom` projection to its underlying `LinearMap`,
then use `LinearMap.sum_apply` (Mathlib `Submodule/LinearMap.lean`
L259) to push the sum past the application:

```lean
-- after `have hom_sum_dist`:
simp only [LinearMap.coe_comp, Function.comp_apply,
  LinearMap.sum_apply]
-- this should distribute (Σ_i f_i.hom) x = Σ_i (f_i.hom x) directly
```

This sidesteps the `?f i`-discriminator-tree HOU issue because
`LinearMap.sum_apply`'s pattern is `(Σ_{i ∈ t} f i) b = Σ_{i ∈ t}
f i b`, which is structurally different from `hom_sum`'s
`(Σ_{i ∈ s} f i).hom = Σ_{i ∈ s} (f i).hom`. The prover noted in their
task result that this approach is "promising but untested in iter-092".

#### Route 2: build the AddMonoidHom explicitly + `map_sum`

The `(.hom)` projection from `ModuleCat (M ⟶ N)` to `M →ₗ[k] N` is the
underlying mechanism Mathlib's `ModuleCat.hom_sum` uses internally.
Build it as an explicit `AddMonoidHom` and apply `map_sum`:

```lean
let homProj : (∏ᶜ Z₁ ⟶ ∏ᶜ Z₂) →+ ((∏ᶜ Z₁) →ₗ[k] (∏ᶜ Z₂)) where
  toFun := ModuleCat.Hom.hom
  map_zero' := ModuleCat.hom_zero
  map_add' := ModuleCat.hom_add
rw [show (∑ i, f_i).hom = homProj (∑ i, f_i) from rfl, map_sum homProj]
```

This bypasses HOU by giving Lean an explicit AddMonoidHomClass instance
that `map_sum` knows how to dispatch on.

#### Route 3: restructure summand via let-binder

Introduce a `let f := fun i => (-1)^↑i • Pi.lift ...` so the
discriminator tree sees the closed `?f i` with `f` a let-binder rather
than a complex lambda:

```lean
set f : Fin (n+1) → (∏ᶜ Z₁ ⟶ ∏ᶜ Z₂) :=
  fun i => (-1)^↑i • Pi.lift (fun i_1 ↦ Pi.π _ (i_1 ∘ ⇑(SimplexCategory.δ i).toOrderHom) ≫ map_φ_i)
show ... = ...
rw [hom_sum_dist f Finset.univ]
```

**Order of preference**: Route 1 (cleanest), then Route 3 (mid),
then Route 2 (most invasive but most likely to succeed if 1 + 3 both
fail).

**iter-093 PROGRESS.md mandate**:
- attempt Route 1 first, then Route 3 if Route 1 fails, then Route 2;
- **use per-step LSP validation now that LSP is available** — commit
  step (b) on its own once it lands, before attempting (c)..(closure);
- if all three routes fail, place trailing `sorry` after the deepest
  validated tactic and document the exact failure mode.

### 2. Re-attempt iter-091 chain (c)+(d-body)+(e)+(f)+(g)+closure

**Only after step (b) is committed and LSP-validated.** The iter-091
chain was structurally correct; it only broke because step (b) (its
prerequisite) didn't fire. Once (b) lands, the iter-091 tactics:

```lean
simp only [map_sum]
simp only [Finset.smul_sum]
refine Finset.sum_congr rfl ?_
intro i _
simp only [Pi.lift_π_apply, ConcreteCategory.comp_apply,
  ModuleCat.hom_smul, LinearMap.smul_apply]
simp only [Pi.smul_apply]
rw [map_mul]
rw [presheafMap_restrict_collapse _ _ _]
rfl
```

should fire — but **must be re-validated per-step with LSP**. The
per-step risk landscape is enumerated in iter-091's `Known Blockers`
section of PROJECT_STATUS.md (carry it forward — the *risks* are real
even though the bare-commit *mandate* is no longer needed).

### 3. Process change: drop the "bare-chain mandate" framing

The iter-091 bare-chain mandate (no `try`, no `first | ... | sorry`)
was the optimal workaround under no-LSP conditions, but it produced
two foundational compile bugs that LSP would have caught immediately.
**Iter-093 returns to per-step incremental commit with LSP
validation** — that's the standard pattern when LSP works. The
"bare-chain" recipe can stay in the Knowledge Base as a historical
note, but should not be re-applied unless LSP becomes unavailable
again.

### 4. Other files — no change

- `Differentials.lean` (5 sorries) — defer.
- `Modules/Monoidal.lean` (1 sorry) — off-limits.
- `Picard/Functor.lean` (1 sorry) — defer (Phase C gating).
- `Jacobian.lean` (1 sorry) — defer (Phase C/E packaging).

The remaining BasicOpenCech sorries (L662, L986, L1014, L1204, L1233)
are all multi-iter blockers (Čech-infra / `IsLocalizedModule.Away`
upstream / `g_R.map_smul'` gating on the chain) — do not assign as
the primary lane until either step (b)/(c)/.../(closure) of
`cechCofaceMap_pi_smul` lands (which unlocks `g_R.map_smul'` at L1204)
or the upstream Mathlib infra surfaces.

## Reusable proof patterns confirmed iter-092

- **Body-local `letI` reconstruction for conclusion-position let-bound
  module instances** (NEW): when a theorem's conclusion contains
  `letI perI : ...; letI h_mod_pi : ...; ∀ (r y), ...`, the
  `letI` block is zeta-reduced and not intro-visible. Reduce `intro` to
  cover only the unreduced let-binders + the universal quantifier args,
  then reconstruct the `letI` block inside the body verbatim.
- **Mathlib `ModuleCat.hom_sum` bind with explicit `(R := k)`** (NEW):
  when a `have`-binding `∀ {M N : ModuleCat.{u} k}, hom_sum_dist...`
  fails on `AddCommMonoid (M.Hom N)` synthesis, supply `(R := k)`
  explicitly: `@fun M N ι => ModuleCat.hom_sum (M := M) (N := N) (R := k)`.
- **Environment repair via `~/.local/bin/` symlinks** (NEW, process):
  if `lake` and `lean` are absent from `$PATH` but present at
  `~/.elan/bin/`, the one-line repair is
  `ln -sf ~/.elan/bin/{lake,lean,elan,leanc,leanchecker,leanmake,leanpkg}
   ~/.local/bin/`. Each prover lane should do this in its first
  investigative pass before assuming LSP unavailability.

## Process-level recommendations

- **Stop using the "bare-chain commit, no LSP" mandate**. Per-step
  incremental commits with LSP validation are the standard now.
- **Verify `lake build` exits 0 BEFORE accepting a "sorry decrement"**.
  Iter-091's "13 sorries" was a syntactic-grep mirage on a non-
  compiling file. The deterministic `sync_leanok` phase should catch
  this — and iter-092 confirms it works: the absence of `\leanok` on
  `cechCofaceMap_pi_smul` in the blueprint correctly reflected the
  compile failure. The plan agent should treat any `sorry`-count
  decrement that isn't `\leanok`-confirmed as **unverified**.
- **Carry the iter-092 retractions into PROGRESS.md / STRATEGY.md
  prose**. Specifically:
  - retire the "Sandbox issue" section,
  - retract "`ModuleCat.hom_sum` is absent" from Knowledge Base /
    Known Blockers,
  - reset the PROJECT_STATUS sorry count to 14 (compile-verified).

## Risk register going into iter-093

| Risk | Severity | Mitigation |
|---|---|---|
| All three step-(b) routes fail | medium | Document each failure mode; if `LinearMap.sum_apply` fires partially, splice it with `let`-rebinding. Commit the deepest validated state. |
| Step (b) lands but step (c) `simp only [map_sum]` regression risk | low–medium | Per-step LSP validation now possible; address per-step. |
| `presheafMap_restrict_collapse` `≤`-witness unification (g) | low | Top-level lemma at L412 is fully proved; supply witnesses via `(Pi.π _ _).le.trans (basicOpen_le _)` if needed. |
| Final `rfl` is not definitional | low | Fallback `simp only [ConcreteCategory.comp_apply]` + `ring`. |
| Foundation regressions (someone re-introduces the L454/L495 patterns) | low | iter-092 task result documents the exact fix; should be propagated as a Known Blocker. |
