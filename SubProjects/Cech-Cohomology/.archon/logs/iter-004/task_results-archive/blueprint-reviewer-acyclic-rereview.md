# Blueprint Review Report

## Slug
acyclic-rereview

## Iteration
003

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:homology_long_exact_sequence` anchor fix confirmed faithful — see anchor verification below.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex — complete + correct, no notes.
### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

(Other two chapters already cleared in iter-003 whole-blueprint review; re-read confirmed no change.)

---

## Anchor verification: `lem:homology_long_exact_sequence`

The prior must-fix was: `\lean{}` named only `homology_exact₃` while the block asserts the
full LES including the connecting morphism δ.

The fixed anchor now names all four declarations:

```
\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₁,
  CategoryTheory.ShortComplex.ShortExact.homology_exact₂,
  CategoryTheory.ShortComplex.ShortExact.homology_exact₃,
  CategoryTheory.ShortComplex.ShortExact.δ}
```

**`lean_run_code` verification** (all resolved without error):

| Declaration | Verified signature |
|---|---|
| `homology_exact₁` | Exactness at `H^j(X₁)`: short complex `(X₃.homology i → X₁.homology j → X₂.homology j)` is Exact, with `f = hS.δ i j hij` |
| `homology_exact₂` | Exactness at `H^i(X₂)`: short complex `(X₁.homology i → X₂.homology i → X₃.homology i)` is Exact |
| `homology_exact₃` | Exactness at `H^i(X₃)`: short complex `(X₂.homology i → X₃.homology i → X₁.homology j)` is Exact, with `g = hS.δ i j hij` |
| `δ` | `S.ShortExact → (i j : ι) → c.Rel i j → (S.X₃.homology i ⟶ S.X₁.homology j)` |

Coverage analysis: `homology_exact₂` covers the middle segment (exactness at `H^n(X₂)`);
`homology_exact₃` covers the segment ending at `H^n(X₃)` and entering δ (exactness at
`H^n(X₃)`); `homology_exact₁` covers the segment starting at δ (exactness at `H^{n+1}(X₁)`).
Together exact₁ + exact₂ + exact₃ assert exactness at every position in the LES, and `δ`
provides the connecting morphism. The anchor is **faithful** to the full LES claim in the
block's prose.

**Other `\mathlibok` anchors** (also verified by `lean_run_code`):

| Label | `\lean{}` | Verdict |
|---|---|---|
| `lem:right_derived_injective_resolution` | `CategoryTheory.InjectiveResolution.isoRightDerivedObj` | ✓ Exists; signature gives `(F.rightDerived n).obj X ≅ H^n(F(I•))` — matches blueprint prose |
| `lem:right_derived_vanishes_injective` | `CategoryTheory.Functor.isZero_rightDerived_obj_injective_succ` | ✓ Exists; `IsZero ((F.rightDerived (n+1)).obj X)` for `[Injective X]` — matches |
| `lem:right_derived_zero_iso_self` | `CategoryTheory.Functor.rightDerivedZeroIsoSelf` | ✓ Exists; `F.rightDerived 0 ≅ F` for `[PreservesFiniteLimits F]` — matches (left-exact ↔ preserves finite limits) |

---

## Dependency & isolation findings

**`leandag build --json`**: `unknown_uses: []` — zero broken `\uses{}` edges.
All cross-references resolve to defined labels.

**Isolated nodes** (`leandag show isolated`): 10 nodes, all `lean_aux` type (uncovered Lean
helper declarations in the existing Lean files, not belonging to any blueprint chapter). No
isolated **blueprint** nodes. Disposition for all 10: **keep** — these are pre-existing Lean
helpers not yet linked to the blueprint; they are not the goal, not stubs, and do not
indicate a missing edge in `Cohomology_AcyclicResolution.tex`.

---

## Rendering integrity

**`archon blueprint-doctor --json`**: `malformed_refs: []` — zero undefined-macro,
math-delim, literal-ref, or bare-label findings across the chapter.

One `covers_problems` entry: `Cohomology_AcyclicResolution.tex` covers
`AlgebraicJacobian/Cohomology/AcyclicResolution.lean` which does not yet exist.
**Not a defect** — the directive explicitly flags this as expected; the file will be scaffolded
this iter.

---

## Proof quality: project declarations

The two project-to-prove lemmas have complete, detailed proof sketches:

**`lem:acyclic_dimension_shift`** (dimension shift across an acyclic SES):
The proof correctly proceeds in two steps. First, it constructs the LES of right-derived
functors by: (a) applying the horseshoe lift (`lem:injective_resolution_of_ses`) to get a
degreewise-split SES of injective resolutions `0 → I_A → I_J → I_Z → 0`; (b) noting that
G carries each degreewise-split short exact sequence to a split SES in `B` (key — G need not
be exact, only additive); (c) applying `lem:homology_long_exact_sequence` to the resulting
SES of complexes `0 → G(I_A) → G(I_J) → G(I_Z) → 0`; (d) transporting across
`lem:right_derived_injective_resolution`. Second, acyclicity of J kills all `(R^k G)(J) = 0`
for `k ≥ 1`, leaving the connecting isomorphisms and the cokernel formula. The `\uses{}` in
both the statement and proof blocks is complete and consistent with this argument.
Sufficiently detailed for a prover to formalize.

**`lem:acyclic_resolution_computes_derived`** (main theorem):
The proof gives the classical dimension-shift induction explicitly. It: (a) introduces
cosyzygies `Z^m = ker(J^m → J^{m+1})` and the SES `0 → Z^m → J^m → Z^{m+1} → 0`; (b)
handles the base degrees `n = 0, 1` directly using left-exactness and
`lem:acyclic_dimension_shift(2)`; (c) runs the staircase `(R^n G)(A) ≅ (R^{n-1} G)(Z^1)
≅ … ≅ (R^1 G)(Z^{n-1})` via `lem:acyclic_dimension_shift(1)`; (d) evaluates the final
`(R^1 G)(Z^{n-1})` as `coker(G(J^{n-1}) → G(Z^n))` and identifies it with `H^n(G(J•))`
via left-exactness of G applied to `(S_n)`. The closing paragraph explicitly traces every
LES invocation back through `lem:acyclic_dimension_shift` to `lem:homology_long_exact_sequence`
and `lem:right_derived_injective_resolution`. The `\uses{}` in the proof block lists all
six supporting declarations. Sufficiently detailed for a prover to formalize.

---

## Citation discipline

All blocks carrying external claims in this chapter:
- Have `% SOURCE: [Stacks Project] ... (read from references/homological-acyclic-derived.tex)` headers.
- Reference file `references/homological-acyclic-derived.tex` **exists on disk** (confirmed).
- Have verbatim `% SOURCE QUOTE:` blocks in the source's original language (English — Stacks Project).
- Carry visible `\textit{Source: Stacks Project, ...}` first-prose lines.
- Proof blocks whose proofs derive from source have `% SOURCE QUOTE PROOF:` annotations
  (e.g. `lem:acyclic_resolution_computes_derived`); where the blueprint uses an alternative
  proof strategy (horseshoe + LES vs. Stacks' derived-category argument), this is
  explicitly noted in a comment and the proof quote is the Stacks source proof
  (`Tag 015E`'s "short exact sequences / collapse" argument).

`lem:injective_resolution_of_ses` cites Weibel in prose but uses no `% SOURCE:` block —
this is correct because it is an Archon-original proof (horseshoe dual) not directly copied
from a single local reference file; the Weibel citation is informational.

No citation-discipline findings.

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

**P4 HARD GATE CLEARS.** The single must-fix from the iter-003 whole-blueprint review
(unfaithful `\mathlibok` anchor on `lem:homology_long_exact_sequence`) has been corrected.
All four Mathlib declarations are verified present with signatures matching the blueprint's
claim. Both project proof sketches (`lem:acyclic_dimension_shift`,
`lem:acyclic_resolution_computes_derived`) are fully supported by the corrected anchor and
sufficiently detailed for prover dispatch. The plan agent may scaffold
`AcyclicResolution.lean` and dispatch a prover this iter.

Overall verdict: `Cohomology_AcyclicResolution.tex` is complete and correct with no
must-fix findings; P4 HARD GATE CLEARS for prover dispatch on `AcyclicResolution.lean`.
