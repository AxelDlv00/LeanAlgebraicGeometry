# Lean ↔ Blueprint Check Report

## Slug
qts

## Iteration
047

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.qcoh_section_isLocalizedModule}` (chapter: `lem:qcoh_section_isLocalizedModule`)

- **Lean target exists**: yes (line 1356)
- **Signature matches**: yes — `IsLocalizedModule (Submonoid.powers f) (ρ_f).hom` where `ρ_f` is the presheaf restriction `Γ(⊤,F) → Γ(D(f),F)`. Matches blueprint prose exactly: "ρ_f exhibits Γ(D(f),F) as the localization of Γ(X,F) at the powers of f."
- **Proof follows sketch**: partial — the Lean proof implements the same equalizer→match→kernel argument described in the blueprint, but does so via the abstract `isLocalizedModule_of_exact` left-exact-ladder lemma (not mentioned in the blueprint sketch). Mathematically equivalent; the blueprint's "passing to kernels yields an isomorphism" is precisely what `isLocalizedModule_of_exact` implements.
- **Red flags**: none. No sorry, no axiom, no placeholder comment.
- **`\lean{}` pin**: correct.
- **`\leanok` present**: yes (both statement and proof blocks).

---

### `\lean{AlgebraicGeometry.qcoh_section_kernel_comparison}` (chapter: `lem:qcoh_section_kernel_comparison`)

- **Lean target exists**: yes (line 1446)
- **Signature matches**: yes — `LocalizedModule (Submonoid.powers f) Γ(X,F) ≃ₗ[R] Γ(D(f),F)`. Matches blueprint: "the canonical R-linear map Γ(X,F)_f → Γ(D(f),F) is an isomorphism."
- **Proof follows sketch**: partial — Lean body is the one-liner `@IsLocalizedModule.iso _ _ (Submonoid.powers f) _ _ _ _ _ _ _ (qcoh_section_isLocalizedModule F f)`. The blueprint proof block contains the full equalizer chase, but that chase is actually carried out inside `qcoh_section_isLocalizedModule`. The mathematical content of the proof block correctly describes what was formalized; it is simply attributed to the wrong declaration.
- **Red flags**: none.
- **`\lean{}` pin**: correct.
- **`\leanok` present**: yes.

---

## Red flags

None. The file contains no `sorry`, no `axiom` declarations, no `Classical.choice` on non-trivial claims, and no excuse-comments.

---

## Unreferenced declarations (informational)

The following four new declarations from iter-047 have no `\lean{...}` reference in the blueprint chapter:

| Declaration | Line | Visibility | Assessment |
|---|---|---|---|
| `isLocalizedModule_of_exact` | 1192 | **public** | **Substantive** — abstract left-exact-ladder kernel comparison. Load-bearing primitive consumed directly by `qcoh_section_isLocalizedModule`. Blueprint comment at line ~5055 explicitly flags: *"NOT yet blueprinted — planner: author a node."* |
| `overlap_target_eq` | 1277 | `private` | Helper only — bookkeeping identity `D((a·b)·f) = D(a·f) ⊓ D(b·f)`. Acceptable unlisted. |
| `presheaf_map_comp₂_apply` | 1290 | `private` | Helper only — triple-presheaf-map composition fold. Acceptable unlisted. |
| `overlap_section_localization` | 1301 | `private` | Near-substantive — per-overlap version of `tile_section_localization`, consumed directly by `qcoh_section_isLocalizedModule`. Derivable from `tile_section_localization` by opens transport; acceptable as unlisted private helper, but worth a blueprint note. |

---

## Blueprint → Lean: the `\uses`-direction discrepancy

**This is a confirmed real discrepancy.**

The blueprint DAG has:

```
lem:qcoh_section_isLocalizedModule  \uses  lem:qcoh_section_kernel_comparison
```

meaning `qcoh_section_isLocalizedModule` depends on `qcoh_section_kernel_comparison`.

The Lean dependency is the **reverse**:

```
qcoh_section_isLocalizedModule   -- proved independently via isLocalizedModule_of_exact
qcoh_section_kernel_comparison   -- one-liner: IsLocalizedModule.iso (qcoh_section_isLocalizedModule F f)
```

`qcoh_section_isLocalizedModule` does **not** call `qcoh_section_kernel_comparison`. `qcoh_section_kernel_comparison` is a corollary that wraps the keystone via `IsLocalizedModule.iso`.

**Does it introduce circularity?** No. The Lean dependency chain is strictly linear and acyclic:

```
isLocalizedModule_of_exact
  ↓
qcoh_section_isLocalizedModule   (uses isLocalizedModule_of_exact)
  ↓
qcoh_section_kernel_comparison   (packages the above as an iso)
```

The blueprint DAG wrongly has the last arrow reversed, but since neither direction creates a cycle (both declarations are proved independently in the original blueprint intent), there is no circularity. The discrepancy is a DAG labeling error, not a logical flaw.

**The blueprint itself acknowledges this.** The `% NOTE:` comment already embedded at line ~5055 reads: *"The `\uses` on `lem:qcoh_section_kernel_comparison` here is INVERTED vs the Lean: in Lean `kernel_comparison` is the packaged-iso form derived FROM this keystone. Planner must flip that edge so the DAG matches Lean."*

**Required fix**: Remove `lem:qcoh_section_kernel_comparison` from `lem:qcoh_section_isLocalizedModule`'s `\uses`, and add `lem:qcoh_section_isLocalizedModule` to `lem:qcoh_section_kernel_comparison`'s `\uses`.

Additionally, `lem:qcoh_section_isLocalizedModule`'s `\uses` list mentions `lem:section_isLocalizedModule_of_presentation` but the Lean proof does not call that lemma directly (the per-tile localization path goes through `tile_section_localization` which itself uses `section_isLocalizedModule_of_presentation`). This transitivity is acceptable in `\uses` (it names any upstream dependency, not just direct calls), so this is not wrong, but worth noting.

---

## Blueprint adequacy for this file

- **Coverage**: 2/6 new declarations have `\lean{...}` references (both substantive ones: `qcoh_section_isLocalizedModule`, `qcoh_section_kernel_comparison`). The 1 non-private unlisted declaration (`isLocalizedModule_of_exact`) is a genuine coverage gap explicitly flagged by the blueprint itself. The 3 private helpers are acceptable.
- **Proof-sketch depth**: **under-specified for `lem:qcoh_section_isLocalizedModule`**. The blueprint proof describes the equalizer argument at the conceptual level ("passing to kernels yields an isomorphism") but does not identify the abstract algebraic primitive (`isLocalizedModule_of_exact`) that implements this step. A prover starting from the blueprint sketch alone would need to independently discover the left-exact-ladder abstraction. The comment in the blueprint acknowledges this.
- **Proof-sketch depth for `lem:qcoh_section_kernel_comparison`**: **misattributed**. The proof block describes the full equalizer chase, but the Lean proof for this declaration is a one-liner. The chase is what `qcoh_section_isLocalizedModule` does. The proof blocks for the two declarations need to be swapped / reconciled to reflect what each Lean proof actually does.
- **Hint precision**: precise. Both `\lean{}` pins name the correct Lean identifiers.
- **Generality**: matches need.

**Recommended chapter-side actions** (for the blueprint-writing subagent):

1. **[must-fix, major]** Flip the `\uses` edge: remove `lem:qcoh_section_kernel_comparison` from `lem:qcoh_section_isLocalizedModule \uses` and add `lem:qcoh_section_isLocalizedModule` to `lem:qcoh_section_kernel_comparison \uses`.

2. **[major]** Author a `\lean{AlgebraicGeometry.isLocalizedModule_of_exact}` blueprint node (tentatively `lem:isLocalizedModule_of_exact`) — abstract left-exact-ladder kernel comparison. Statement: given a commutative ladder with both rows left-exact and the right two vertical maps localizations at `S`, the left vertical map is also a localization at `S`. It should be listed in `lem:qcoh_section_isLocalizedModule \uses`. The blueprint comment already instructs the planner to do this.

3. **[minor]** Reconcile the proof blocks: the long equalizer chase in `lem:qcoh_section_kernel_comparison`'s proof block belongs in `lem:qcoh_section_isLocalizedModule`'s proof block (with `isLocalizedModule_of_exact` as the closing step). The `lem:qcoh_section_kernel_comparison` proof block should then become a one-liner: "immediate from `lem:qcoh_section_isLocalizedModule` via `IsLocalizedModule.iso`."

4. **[minor]** Consider adding a private-helper note for `overlap_section_localization` (the per-overlap localization that is `tile_section_localization` for `g = a·b` transported along the overlap opens identity). Not required, but would improve traceability.

---

## Severity summary

| Item | Severity | Description |
|---|---|---|
| `\uses`-direction inversion (`isLocalizedModule \uses kernel_comparison` in blueprint, reversed in Lean) | **major** | Real DAG error. No circularity; blueprint itself flags it. Requires flipping the edge. |
| `isLocalizedModule_of_exact` not blueprinted | **major** | Substantive non-private abstract algebra primitive used directly in the keystone proof. Blueprint comment explicitly calls for a new node. |
| Proof blocks of `kernel_comparison` and `isLocalizedModule` describe each other's content | **minor** | Narrative confusion; no mathematical wrongness. Proof blocks need swapping/reconciliation. |
| `overlap_section_localization` private helper not in blueprint | **minor** | Near-substantive private helper consumed by the keystone. No blueprint entry required but worth a note. |

**Overall verdict**: The two `\lean{}`-pinned declarations (`qcoh_section_isLocalizedModule` and `qcoh_section_kernel_comparison`) are axiom-clean, correctly typed, and match their blueprint statements; the Lean is faithful to the mathematical content. The blueprint has two real structural issues that need planner attention: one inverted `\uses` edge (already self-identified in blueprint comments) and one missing node for `isLocalizedModule_of_exact`.
