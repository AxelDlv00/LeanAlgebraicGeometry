# Session 219 (review of iter-219)

## Metadata
- **Iteration / session**: iter-219 / session_219
- **Sorry count**: project **80 → 80** (net **0**); file `TensorObjSubstrate.lean` code sorries **3 → 3** (L632, L1559, L1603 — all pre-existing, untouched).
- **sync_leanok**: ran iter-219, sha `93a7e3b2`, **+0 / −0**, chapters_touched: none.
- **Mode**: `mathlib-build` (no-sorry invariant) on `Picard/TensorObjSubstrate.lean`.
- **Target attempted**: build `PresheafOfModules.internalHom` (first sub-step of the funded ⊗-dual internal-hom infra block, blueprint `sec:tensorobj_dual_infra`). `exists_tensorObj_inverse` / `addCommGroup_via_tensorObj` were FORBIDDEN this iter (anti-pattern guard).

## Outcome — the "first brick of the funded infra block lands, value-level pessimism refuted" iter

iter-218 hit the pre-committed INCOMPLETE gate: the ⊗-inverse needs a Mathlib-absent internal-hom/dual for `SheafOfModules`. The iter-219 planner ran the scheduled mathlib-analogist consult (ts219dual), which returned **NEEDS_MATHLIB_GAP_FILL on all three faces** (presheaf, sheaf, categorical level — same missing object; ~6–12 iters / ~300–500 LOC, ≥ the abandoned d.2). The planner then COMMITTED to the Decision-1 sheaf internal-hom build (Route-A-forced; the ⊗-inverse is unavoidable for a group-valued relative Picard functor on non-reduced test schemes) and dispatched a `mathlib-build` prover on the **first sub-step**.

The prover **built the per-object VALUE module axiom-clean** — 11 declarations in a new `namespace PresheafOfModules.InternalHom` (L996–1129), no sorry in any addition. The central deliverables:
- **`homModule`** — the `R(T)`-module structure on `Hom(M,N)` of presheaves of modules over a base category `C` with terminal object `T`; scalar `f ∈ R(T)` acts by post-composition with `globalSMul f : N ⟶ N`.
- **`internalHomObjModule`** — the slice value `Hom(M|_U, N|_U)` as an `R(U)`-module, i.e. the per-object VALUE of `def:presheaf_internal_hom`, via `homModule` specialised to `T := Over.mk (𝟙 U)` (terminal of `Over U`) and `M|_U = restr U M = pushforward₀ (Over.forget U) M`.

This **refutes the analogist's value-level pessimism**: the internal hom is absent from Mathlib at every level, but the genuinely-hard reusable core (the `R(U)`-module on the morphism group for the *varying* structure sheaf) is now built and reusable.

## Verification (first-hand)

- `PresheafOfModules.InternalHom.internalHomObjModule` and `…homModule` both `lean_verify` = `{propext, Classical.choice, Quot.sound}` — no `sorryAx`, no project axiom. (The L1459 `lean_verify` "opaque" warning is the known docstring comment-scan false positive.)
- File code sorries confirmed = **3** (L632 `isLocallyInjective_whiskerLeft_of_W`, L1559 `exists_tensorObj_inverse`, L1603 `addCommGroup_via_tensorObj`) — all pre-existing, all untouched; the 11 additions contain none.
- blueprint-doctor: **clean** (no orphan chapters, every `\ref`/`\uses` resolves, no `axiom` decls).
- Two independent review subagents (below) both returned **0 must-fix** and judged the 11 decls genuine.

## Attempts (from attempts_raw.jsonl — 4 edits, 1 transient error, 3 clean diagnostics)

1. **`homModule`** (L1082) — `Module (R.obj (op T)) (M ⟶ N)`, `smul f φ := φ ≫ globalSMul hT N f`. All six axioms proved through established lemmas (`globalSMul_one`+`Category.comp_id`; `globalSMul_mul`+`Category.assoc`; `Limits.zero_comp`; `globalSMul_zero`+`Limits.comp_zero`; `Preadditive.add_comp`; `globalSMul_add`+`Preadditive.comp_add`). Result: **success, axiom-clean.**
2. **`internalHomObjModule`** (L1123) + **`restr`** (L1112) — slice specialisation via `Over.mkIdTerminal`/`Over.forget`. Result: **success, axiom-clean.** Insight: the over-category restriction realises the covariant slice formula concretely; ring-at-terminal `= R(U)` by `rfl`.
3. **`map_add` ambiguity fix** in `globalSMul_add` — `rw [add_app, globalSMul_hom_apply, map_add, add_smul]` → `_root_.map_add` (ambiguous with `Functor.map_add` under `open CategoryTheory`). Result: **success.**
4. The transient error logged in the summary stats was resolved within the session (final build GREEN; 3 clean diagnostics).

## Key findings / reusable patterns

See the new PROJECT_STATUS Knowledge Base entry "slice internal-hom VALUE module is buildable project-side and axiom-clean" for the full recipe + the three recurring gotchas (CommRingCat/RingCat carrier duality → use `erw`; `map_add` ambiguous → `_root_.map_add`; `ModuleCat.of` of a hom-module fragile → return bare `Module`). Memory `[[ts219-internalhom-value-built]]` mirrors it.

## Review subagents dispatched

- **lean-auditor ts219** (`task_results/lean-auditor-ts219.md`): **0 must-fix**, 2 major, 4 minor. The 11 new decls are "mathematically sound, axiom-clean, introduce no new sorries; every module axiom in `homModule` genuinely proved." Both majors are **stale block comments** misrepresenting sorry/scaffold status of OLDER decls (L37–85 "file-skeleton scaffold" header; L1567 `tensorObjOnProduct` docstring "typed sorry" but body is complete). Minors are stale iter numbers in docstrings.
- **lean-vs-blueprint-checker ts219** (`task_results/lean-vs-blueprint-checker-ts219.md`): **0 must-fix**. The 11 decls faithfully realize the blueprint slice formula; the `\lean{PresheafOfModules.internalHom}` pin correctly names the not-yet-built full presheaf (no `\leanok`, so no laundering). 2 major (blueprint-side): (a) `homModule`/`internalHomObjModule` are substantive intermediate deliverables with no `\lean{}` pin — add named sub-step pins; (b) the presheaf-assembly restriction-map step (`V ⟶ U`) is under-specified in the blueprint (no Lean target name). Minor: `lem:presheaf_pushforward_adj_substrate` and `lem:tensorobj_unit_iso` lack `\leanok` despite sorry-free decls (sync observation — see below).

## sync_leanok observation (note, not a CRITICAL)

sync ran THIS iter (`iter`=219 in `sync_leanok-state.json`), so all marker states are the script's deterministic verdict. The lvb checker flagged that `lem:presheaf_pushforward_adj_substrate` (5 decls, built iter-217, axiom-clean) and `lem:tensorobj_unit_iso` (2 decls, sorry-free) carry no `\leanok`. Since sync added 0/removed 0 this iter, this is a standing under-marking the script is not adding — likely the multi-decl `\lean{a,b,c,…}` block form requiring ALL named decls present, or a statement-vs-proof block distinction. I did **not** add `\leanok` (review agents must not). Flagged for the plan agent in recommendations.

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, `def:presheaf_internal_hom`: added `% NOTE:` recording that the per-object VALUE module is now built (`PresheafOfModules.InternalHom.{homModule, internalHomObjModule, restr}`), that the `\lean{}` pin names the eventual full presheaf, and that the plan agent should add intermediate pins + expand the presheaf-assembly restriction-map step (per lvb ts219).
