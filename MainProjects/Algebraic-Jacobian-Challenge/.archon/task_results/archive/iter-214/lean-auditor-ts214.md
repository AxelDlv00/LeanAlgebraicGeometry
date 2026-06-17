# Lean Audit Report

## Slug
ts214

## Iteration
214

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 8 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: 0 flagged
- **notes**:
  - L37–86 (module docstring `## Status` section): claims "each of the 4 pinned declarations carries a `sorry` body". This is false for two of them: `tensorObj` (L640–643) and `tensorObj_functoriality` (L657–660) both have real, non-sorry bodies. The third item (`monoidalCategory`) refers to a declaration that was deliberately removed at iter-206 (see §2, L672–684). Only `addCommGroup_via_tensorObj` is still a typed sorry. The status block is comprehensively stale.
  - L47–52 (module docstring, item 1): "the body is a typed `sorry`" for `tensorObj` — incorrect; the body lifts `PresheafOfModules.Monoidal.tensorObj` through `sheafification` at L641–643.
  - L53–58 (module docstring, item 2): "the body is a typed `sorry`" for `tensorObj_functoriality` — incorrect; the body applies `sheafification.map (tensorHom ...)` at L658–660.
  - L59–65 (module docstring, item 3): describes `monoidalCategory` as a blueprint-pinned declaration "Per blueprint `thm:scheme_modules_monoidal`". This declaration does not exist in the file. It was deliberately removed at iter-206 (§2 note, L672–684). The module-level docstring still counts it as one of the 4 scaffold pins.
  - L178–190 (section header `FlatWhisker`): states that `W_whisker{Left,Right}_of_flat` is "the single non-formal ingredient of the `⊗`-invertibility associator `tensorObj_assoc_iso`". This is directly contradicted by L365–380, which explicitly says the flat-whiskering route is "OFF the associator critical path (iter-212 finding)" because sectionwise flatness of line bundles over non-affine opens fails. The two comments are internally contradictory.
  - L323–331 (docstring for `W_whiskerLeft_of_flat`): repeats the stale claim "This is the single non-formal ingredient of the `⊗`-invertibility associator `tensorObj_assoc_iso`". Stale since iter-212.
  - L629–639 (docstring for `tensorObj` declaration): "iter-202 Lane TS scaffold: the body is a typed `sorry`; the iter-203+ body lifts…". The iter-203+ body IS present. This docstring has not been updated.
  - L645–655 (docstring for `tensorObj_functoriality` declaration): same pattern — "iter-202 Lane TS scaffold: the body is a typed `sorry`". The iter-203+ body IS present.
  - L763 (status note in `tensorObj_assoc_iso` docstring): says "typed `sorry`". The body at L803–843 is a real proof term ending with `exact (@asIso _ _ _ _ _ hi1).symm ≪≫ e2 ≪≫ (@asIso _ _ _ _ _ hi3)` — there is no `sorry` in the body. The declaration IS sorry-dependent transitively (via `isLocallyInjective_whiskerLeft_of_W`), but calling it "typed sorry" is inaccurate.
  - L411–415 (`isLocallyInjective_whiskerLeft_of_W` type signature): stated over a general Grothendieck topology `C`. The body comment at L428–429 explicitly acknowledges that "the general-site statement here has no stalks; decl is UNPROTECTED so the specialisation is free, and the only consumer `tensorObj_assoc_iso` already works over `Opens.grothendieckTopology X`". The sorry cannot be closed at this generality — stalkwise arguments require `C = Opens X`. The over-general signature is a known mismatch with a planned (but not yet executed) specialisation.
  - L1048: `@[implicit_reducible]` on a sorry'd `def` (`addCommGroup_via_tensorObj`). Harmless but unusual — the attribute affects typeclass search reducibility, which is moot while the body is `sorry`. Minor practice observation.

---

## Focus area findings

### `StalkLinearMap` section (L521–617) — germ-chase audit

The four new declarations are:

**`stalkLinearMap` (L535–570).** The `map_smul'` proof is a germ-chase. Tracing the rewrite chain at L569–570:

```lean
rw [hr, hs, ← PresheafOfModules.germ_smul M x W hxW, key, map_smul,
    PresheafOfModules.germ_smul N x W hxW, key]
```

Step-by-step:
1. `hr` / `hs`: substitutes `germ_U r₀` and `germ_V s₀` for their restrictions to the common open `W = U ⊓ V`. Honest use of `germ_res_apply`.
2. `← germ_smul M`: in the LHS, rewrites `germ_R_W r_W • germ_M_W s_W` to `germ_M_W (r_W • s_W)` (reverse of the scalar-germ identity). Pattern is present because both sides of `•` are now germs at `W`.
3. `key` (first use): rewrites `stalkFunctor.map g (germ_M_W z)` → `germ_N_W (g.app (op W) z)` for `z = r_W • s_W`. The `key` lemma (L557–568) is proved using `toPresheaf_map_app_apply` + `TopCat.Presheaf.stalkFunctor_map_germ_apply` — both standard.
4. `map_smul`: rewrites `g.app (op W) (r_W • s_W)` to `r_W • g.app (op W) s_W` using `R.obj (op W)`-linearity of `g.app (op W)` in `ModuleCat`. Correct: `g` is a morphism in `PresheafOfModules`, so each `g.app` is a linear map.
5. `germ_smul N x W hxW`: rewrites `germ_N_W (r_W • z)` to `germ_R_W r_W • germ_N_W z` (forward direction). Correct application.
6. `key` (second use): rewrites `stalkFunctor.map g (germ_M_W s_W)` in the RHS to `germ_N_W (g.app (op W) s_W)`. At this point both sides are `germ_R_W r_W • germ_N_W (g.app (op W) s_W)` and close by `rfl`.

**Verdict: the germ chase is honest.** No vacuous rewrite, no `sorry`, no `admit`, no `native_decide`. Every step has a matching Mathlib lemma. ✓

**`stalkLinearMap_germ` (L576–589).** Unfolds the definition via `change`, then reduces to `stalkFunctor_map_germ_apply` after adjusting `g.app` vs `(toPresheaf _).map g).app` via `toPresheaf_map_app_apply`. Clean. ✓

**`stalkLinearMap_bijective_of_isIso` (L597–603).** `change` exposes the underlying function; `ConcreteCategory.bijective_of_isIso` closes. Correct — `IsIso` in `AddCommGrpCat` implies bijectivity. ✓

**`stalkLinearEquivOfIsIso` (L610–615).** One-liner: `LinearEquiv.ofBijective (stalkLinearMap g x) (stalkLinearMap_bijective_of_isIso g x h)`. Correct use of the constructor. ✓

**No axioms introduced** in the `StalkLinearMap` section. All four declarations are axiom-clean (no `sorry`, no `axiom`, no `Classical.choice _`). ✓

### Sorry inventory audit

| Declaration | Line | Sorry type | Body comment accurate? |
|---|---|---|---|
| `isLocallyInjective_whiskerLeft_of_W` | L443 | Typed sorry | Yes — describes d.1-bridge + d.2 residuals precisely. Does NOT over-claim. ✓ |
| `tensorObj_restrict_iso` | L970 | Typed sorry | Yes — documents the correct decomposition (H1+H2 at L943–969). ✓ |
| `exists_tensorObj_inverse` | L1013 | Bare sorry (no body comment) | No body comment. Docstring says "iter-202 Lane TS scaffold: typed `sorry`; the iter-203+ body builds the dual…". No regression from prior iters; untouched typed sorry. ✓ |
| `addCommGroup_via_tensorObj` | L1052 | Bare sorry | Docstring describes the closure target. Untouched typed sorry. ✓ |

All four are untouched typed sorries. None are regressions (no content removed, no new `sorry` injected into formerly-proved code). ✓

### `isLocallyInjective_whiskerLeft_of_W` body comment (L416–442)

The comment accurately states:
- The stalkwise route: `(F ◁ g)_x = id_{F_x} ⊗ g_x` is iso when `g` is in `J.W`.
- iter-214 correction: `Mathlib.Algebra.Category.ModuleCat.Stalk` IS present; `stalkLinearMap` etc. now built project-side.
- TWO remaining gaps: (d.1-bridge) the `J.W ↔ stalkwise iso` characterisation and (d.2) the `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x` stalk-commutation.

The comment does NOT over-claim. It correctly identifies both gaps and does not say the sorry is "almost done" or "just one step away" without justification. ✓

---

## Must-fix-this-iter

*(none)*

No finding in this file meets the must-fix criteria:
- No excuse-comments (no declaration admits to using a wrong-but-expedient body).
- No weakened-wrong definitions (the four sorries are explicitly acknowledged residuals, not stand-ins for a different concept).
- No parallel Mathlib API (the presheaf-level `restrictScalarsLaxMonoidal` lifts the module-level `ModuleCat.instLaxMonoidalRestrictScalars` to a genuinely new level — not a copy-and-modify of an existing Mathlib instance).
- No suspect bodies on closed claims (all non-sorry bodies read as structurally correct).
- No unauthorized axioms.

---

## Major

- `TensorObjSubstrate.lean:37–86` — Module docstring `## Status` section is comprehensively stale: (a) asserts `tensorObj` and `tensorObj_functoriality` carry typed-sorry bodies when both have real bodies; (b) lists `monoidalCategory` as a 4th blueprint-pinned declaration that no longer exists in the file.
- `TensorObjSubstrate.lean:47–52` — Module docstring item 1: "body is a typed `sorry`" for `tensorObj`. False; body present since iter-203.
- `TensorObjSubstrate.lean:53–58` — Module docstring item 2: "body is a typed `sorry`" for `tensorObj_functoriality`. False; body present since iter-203.
- `TensorObjSubstrate.lean:59–65` — Module docstring item 3: describes `monoidalCategory` as a blueprint-pinned live declaration. This declaration was deliberately removed at iter-206 (§2, L672–684).
- `TensorObjSubstrate.lean:178–190` and `TensorObjSubstrate.lean:323–331` — `FlatWhisker` section header and `W_whiskerLeft_of_flat` docstring both claim the flat-whiskering lemmas are "the single non-formal ingredient of `tensorObj_assoc_iso`". This is internally contradicted by L365–380, which explicitly states the flat route is "OFF the associator critical path (iter-212 finding)". Two comments in the same file assert opposite things.
- `TensorObjSubstrate.lean:629–639` — `tensorObj` declaration docstring: "iter-202 Lane TS scaffold: the body is a typed `sorry`". The body is real.
- `TensorObjSubstrate.lean:645–655` — `tensorObj_functoriality` declaration docstring: same inaccuracy.
- `TensorObjSubstrate.lean:411–415` — `isLocallyInjective_whiskerLeft_of_W` is typed over a general Grothendieck topology `C` but can only ever be closed (and is only consumed by `tensorObj_assoc_iso`, which is specialised to `Opens.grothendieckTopology X`) over a topological site with enough points. The sorry cannot be closed at this generality. Body comment acknowledges the mismatch ("decl is UNPROTECTED so the specialisation is free"), but the type signature is an over-claim that will never be discharged as stated.

---

## Minor

- `TensorObjSubstrate.lean:763` — `tensorObj_assoc_iso` docstring says "typed `sorry`". The body (L803–843) is a complete `exact` proof term; the declaration is sorry-*dependent* (via `isLocallyInjective_whiskerLeft_of_W`) but not itself sorry'd. Should read "sorry-dependent" or "proof builds on the residual sorry of `isLocallyInjective_whiskerLeft_of_W`".
- `TensorObjSubstrate.lean:1048` — `@[implicit_reducible]` on the sorry'd def `addCommGroup_via_tensorObj`. The attribute is harmless while the body is `sorry`, but unusual and could mislead a reader about the declaration's intended transparency level.
- Throughout — accumulated multi-iter route narrative (routes c/d/e, iter-202/203/206/212/214 references embedded in section headers and docstrings) creates significant cognitive clutter. Individually each note is period-accurate, but the cumulative effect obscures the current state. No single location rises to a formal finding, but the file would benefit from a comment-cleanup pass.

---

## Excuse-comments (always called out separately)

*(none)*

No excuse-comment found. The sorry bodies are honestly documented research residuals with specific identified gaps, not admissions that the code is wrong-but-working.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 8
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: The file's substantive Lean is sound — the new `StalkLinearMap` section is axiom-clean and its germ-chase proof is correct, the four typed sorries are honest residuals with accurate body documentation, and no regressions were introduced. The defects are entirely in accumulated stale documentation: two blueprint-pinned declaration docstrings still claim their bodies are typed sorries when real bodies have been present since iter-203, the module-level status section references a removed declaration (`monoidalCategory`), and the `FlatWhisker` section header contradicts the iter-212 pivot note within the same file.
