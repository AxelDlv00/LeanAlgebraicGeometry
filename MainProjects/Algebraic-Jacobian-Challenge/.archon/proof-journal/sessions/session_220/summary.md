# Session 220 — review of iter-220

## Metadata

- **Session / iter**: session_220 = review of iter-220.
- **Lane**: TS (`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`), the funded Decision-1 sheaf
  internal-hom build (committed iter-219; ~6–12 iter estimate, elapsed 2).
- **Mode**: mathlib-build (no-sorry invariant; build a missing Mathlib ingredient project-side).
- **Sorry count**: file code sorries **3 → 3** (L632, L1733, L1777 — all untouched, all
  pre-existing). Project counter flat (80 entering, no elimination this iter — expected for a
  mathlib-build iter that adds infrastructure, not closures).
- **Build**: GREEN. blueprint-doctor: clean (no orphans, all refs resolve, no `axiom` decls).
- **sync_leanok**: ran iter-220, sha `11c427a0`, **+3 / −0**, `Picard_TensorObjSubstrate.tex` only
  (the three blocks `def:presheaf_internal_hom_value`, `_slice_value`,
  `lem:presheaf_internal_hom_restriction`).

## Headline outcome — the funded build hit its iter-220 success bar

iter-219 left the per-object value module (`homModule`/`internalHomObjModule`). iter-220 built the
**restriction maps**, proved their functoriality + semilinearity, and **ASSEMBLED the full presheaf
internal hom** `PresheafOfModules.InternalHom.internalHom` — completing **sub-step 2 of 5** and the
funded build's explicitly-stated iter-220 success target. **12 new declarations, all axiom-clean**
(`#print axioms` = `{propext, Classical.choice, Quot.sound}` — re-verified first-hand on
`internalHom`; the L1633 "opaque" warning is the known docstring-scan false positive).

New declarations (all `namespace PresheafOfModules.InternalHom`):
`restrictionMap` (def, via `pushforward₀ (Over.map g)`), `restrictionMap_add/_zero` (`ext1 X; rfl`),
`hom_app_heq` (private), `restrictionMap_id/_comp` (functoriality), `restrictionMap_comp_hom`,
`restrictionMap_globalSMul` (semilinearity core), `restrictionMapAddHom` (`→+`),
`internalHomPresheaf` (the `Ab`-valued presheaf), `restrictionMap_smul`, and `internalHom`
(the assembly via `PresheafOfModules.ofPresheaf`).

## The two genuinely hard pieces (both closed axiom-clean)

### 1. Functoriality of `restrictionMap` in `g` — the `Over.map` pseudofunctor coherence

`Over.map` is only *pseudo*functorial: `Over.mapId_eq` / `Over.mapComp_eq` are propositional, NOT
defeq, so `map_id` / `map_comp` are not `rfl`. The prover burned ~6 failed attempts on this:

- `ext1 X; conv_rhs => rw [← hobj X]` → **"Motive is dependent"** (the type of `φ.app X` depends on `X`).
- `exact (hobj X) ▸ rfl` → **type mismatch** (`rfl : ?m = ?m` not the dependent goal).
- `φ.naturality_apply (eqToHom (hobj X)) m` → **`naturality_apply` does not exist** (only
  `PresheafOfModules.Hom.naturality`).

**The crack (reusable):** a private helper
`hom_app_heq φ (h : X = Y) : HEq (φ.app X) (φ.app Y)` proved by `subst h; rfl`. Because the slice
restriction depends only on `.left` (identical for the reindexed objects), the source/target modules
are defeq, so `restrictionMap_id`/`restrictionMap_comp` close by
`exact eq_of_heq (hom_app_heq φ (by rw [Over.mapComp_eq]; rfl))`. This is the general device for any
`pushforward₀ (Over.map -)`-based functoriality coherence.

### 2. `restrictionMap_globalSMul` — the semilinearity core

Reduces to a scalar equality across the two slice bases `(Over.forget U)` / `(Over.forget V)`. The
load-bearing step is the underlying `Over` morphism identity
`(mkIdTerminal.from ((Over.map g).obj Y)).left = (mkIdTerminal.from Y).left ≫ g`, proved via `Over.w`
on the terminal map. Final reduction needs `erw [← CommRingCat.comp_apply, ← R.map_comp]; rfl` (the
CommRingCat/RingCat carrier defeq resists plain `rw`).

## Assembly gotchas (universe + carrier diamond)

- **Universe**: `PresheafOfModules.ofPresheaf` ties the underlying `Ab`-presheaf to the ground ring's
  `RingCat.{u}`, but for a general base `C : Type uC [Category.{vC, uC} C]` the morphism groups
  `M|_U ⟶ N|_U` live in `Type (max u uC vC)`. They coincide (→ `Type u`) iff the base is
  single-universe (`Category.{u, u}`). So `internalHomPresheaf` is built universe-polymorphic at
  `AddCommGrpCat.{max u uC vC}`, but `internalHom` is stated in a fresh single-universe section
  (`variable {D : Type u} [Category.{u,u} D] {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}`) — exactly the topological
  site `Opens X` (`SmallCategory.{u}`) the dual ultimately needs. No generality lost.
- **Mathlib name**: `AddCommGrp.of` does not exist; the name is `AddCommGrpCat.of` /
  `AddCommGrpCat.ofHom` (`abbrev Ab := AddCommGrpCat`). The presheaf functoriality `map_id`/`map_comp`
  need `apply AddCommGrpCat.hom_ext; refine AddMonoidHom.ext fun φ => ?_` (plain `ext φ` mismatches the
  universe in the `Eq`).
- **Carrier diamond**: `internalHomObjModule`'s `Module` instance is over `CommRingCat` `R₀.obj`,
  while `ofPresheaf` wants `(R₀ ⋙ forget₂).obj` (`RingCat`). A `letI` Module binding is
  kernel-rejected (diamond). **Must pass the instance explicitly via `@ofPresheaf D _ (R₀ ⋙ forget₂ …)
  (internalHomPresheaf M N) (fun X => internalHomObjModule X.unop M N) (fun {_ _} f r m =>
  restrictionMap_smul f M N r m)`**; `ofPresheaf`'s `set_option backward.isDefEq.respectTransparency
  false` then accepts the defeq carriers.

## Review-subagent findings

Both subagents (reports auto-archived to `logs/iter-220/`):

- **lean-auditor ts220** — `task_results/lean-auditor-ts220.md`. 0 must-fix; the 12-decl block is
  axiom-clean and sorry-free. 3 **major** stale/omission items (see recommendations): missing
  `@[implicit_reducible]` on `internalHomObjModule` (L1117; a class-type `def` whose companion
  `homModule` carries the attribute — compiler warning, potential downstream instance-search failure),
  stale module-level status block (L37–45 claims all 4 pinned decls carry `sorry`, but `tensorObj`/
  `tensorObj_functoriality` are now closed), stale `internalHomObjModule` docstring (L1122 says
  `internalHom` "is the remaining downstream build" — it was assembled in the same block). 4 minor
  (3 `erw` fragility sites + the pre-existing 14× deprecated `Sheaf.val` cluster).
- **lean-vs-blueprint-checker ts220** — `task_results/lean-vs-blueprint-checker-ts220.md`. 4/4 pinned
  decls match (signatures + proof strategy faithful, no fake/weakened statements). 1 **must-fix**: the
  `\lean{}` name mismatch on `def:presheaf_internal_hom` (`PresheafOfModules.internalHom` vs built
  `PresheafOfModules.InternalHom.internalHom`) — **RESOLVED THIS ITER** (I corrected the marker, see
  below). 2 minor blueprint-adequacy items for the next sub-steps (split `lem:internal_hom_isSheaf`
  into sheaf-condition + dual-object pins; annotate `internalHomPresheaf`).

## Is this churn? — no: a funded build landing its scheduled brick

The global counter has not moved since iter-217's 81→80. The mechanical read is "stall". The honest
read: iter-220 is the **second of a deliberately-committed multi-iter block**, and it retired its
named sub-step (sub-step 2: restriction maps + assembly) exactly on its stated success bar, axiom-
clean, with both review subagents judging the additions genuine and faithful. The progress-critic's
CHURNING-by-rule is the mechanical PARTIAL×3 trigger over a window spanning the substrate era + the
new sub-phase; the corrective (the funded build, tracked by sub-step retirement vs the ~6–12 iter
estimate) is already in place. The distinguishing evidence vs churn: the helpers ARE the target
construction (not wrappers around an unmoving residual), and the prover delivered a precise
next-chunk decomposition (sub-steps 3–5).

## Blueprint markers updated (manual)

- `Picard_TensorObjSubstrate.tex`, `def:presheaf_internal_hom`: corrected
  `\lean{PresheafOfModules.internalHom}` → `\lean{PresheafOfModules.InternalHom.internalHom}` (the
  built decl lives in the `InternalHom` namespace). This was the lvb ts220 must-fix; resolving it
  lets the next `sync_leanok` add `\leanok` to the block (the body is axiom-clean). No `\leanok`
  added by me (sync_leanok's domain).

No `\mathlibok` added (the new decls are project constructions, not Mathlib re-exports). No stale
`\notready` to strip.

## Recommendations for next session

See `recommendations.md`. Headline: continue the funded build at **sub-step 3** (dual alias +
`internalHomEval`), but FIRST have the plan agent action the lvb minor (split `lem:internal_hom_isSheaf`)
and the lean-auditor majors (add `@[implicit_reducible]` to `internalHomObjModule`; refresh the two
stale docstrings + the L37–45 status block). Do NOT re-dispatch `prove` on `exists_tensorObj_inverse`
(L1733) — it is infra-bound until the sheaf-level dual lands.
