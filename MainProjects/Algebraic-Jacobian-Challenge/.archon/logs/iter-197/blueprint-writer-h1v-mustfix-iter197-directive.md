# blueprint-writer directive — H1Vanishing must-fix iter-197

## Chapter
`blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`

## Strategy context (slice that matters)

The H1Vanishing chapter underpins Route C (genus-0 rigidity) RR.2 — H¹
vanishing for skyscraper sheaves on a smooth proper geom-irred curve
over an algebraically closed field. The headline target is
`H1_skyscraperSheaf_finrank_eq_zero` (Lean L965) which composes
`skyscraperSheaf_isFlasque` + `HModule_flasque_eq_zero` at i=1.

Two iter-196 Lane H targets remain unclosed in Lean:
- `IsFlasque.constant_of_irreducible` (Lean L138) — empty branch closed
  axiom-clean iter-196; non-empty branch still typed sorry.
- `skyscraperSheaf_eq_pushforward_const` (Lean L818) — outer step closed
  axiom-clean iter-196 via `ObjectProperty.FullSubcategory.ext`; inner
  iso `skyscraperSheaf PUnit.unit A ≅ (constantSheaf J_punit).obj A`
  still typed sorry. The Lean signature wraps the result in `Nonempty`.

The lean-vs-blueprint-checker iter-196 (`task_results/lean-vs-blueprint-checker-h1v.md`)
flagged **3 must-fix-this-iter** items + several majors. HARD GATE
applies to `H1Vanishing.lean` prover re-dispatch until this chapter is
patched and a scoped re-review clears it.

## Must-fix this iter (per lean-vs-blueprint-checker `h1v` iter-196)

### M-1. Acknowledge the Mathlib gap in the `constant_of_irreducible` non-empty branch sketch

**Current state (chapter L171-181)**: the proof sketch says the
non-empty branch follows because "the restriction map is the identity
on A — in particular surjective". This presents it as immediate.

**Reality**: in Lean, the non-empty branch requires the sheafification
unit `η : (Functor.const Cᵒᵖ).obj A → ((constantSheaf J D).obj A).val`
to be an iso on every non-empty open of an irreducible space. Mathlib
`b80f227` does NOT ship this lemma. The Lean comment at H1Vanishing.lean:150-154
documents the gap; the blueprint must too.

**Action**: Add a `% NOTE:` comment block to the proof block of
`lem:isFlasque_constant_irreducible` acknowledging:
- on irreducible X, every non-empty open is connected/dense, so a
  locally-constant sheafification coincides with the literal constant
  presheaf pointwise — this is the underlying mathematical fact;
- formalising this requires either the plus-construction infrastructure
  (`Sheaf.IsConstant` framework for irreducible spaces) or a direct
  unit-iso-on-non-empty-opens computation;
- two known Lean routes (Route A: provide the `Full`/`Faithful`
  instances for `(constantSheaf J D)` on `IrreducibleSpace X`; Route B:
  build the alternate sheaf `P'(U) = A` for `U ≠ ⊥`, `0` otherwise, on
  irreducible X and exhibit `(constantSheaf J D).obj A ≅ ⟨P', _⟩`);
- the LOC envelope per route is ~100–200 LOC standalone.

The `% NOTE:` must be precise enough that the iter-197 prover knows
exactly which route is intended. Use Route A (the Mathlib upstreaming
candidate) as the primary; describe Route B as the fallback.

### M-2. Document the `Nonempty (iso)` weakening in `skyscraperSheaf_eq_pushforward_const`

**Current state (chapter L400 statement + L424-437 proof)**: the
blueprint claims a concrete isomorphism between `skyscraperSheaf P A`
and the pushforward of the constant sheaf on PUnit. The Lean
statement is `Nonempty (skyscraperSheaf P A ≅ ...)` — materially
weaker.

**Action**:
- Update the `\begin{lemma}` block's prose to explicitly state
  `Nonempty (iso)` (not just "naturally isomorphic"). Cite the reason:
  the constructed `iso` is non-computable (uses `Classical.choice` to
  unwrap the inner-iso typed sorry).
- Add a `% NOTE:` describing the future work — when the inner iso
  is replaced by a constructive build, the `Nonempty` wrapper can be
  dropped to a direct `iso` statement.

### M-3. Add a sub-step block for the inner iso (the actual blocking step)

**Current state**: the proof sketch (L424-437) describes a pointwise
argument at the presheaf level. The actual blocking technical step
in Lean is the **inner** iso
`skyscraperSheaf PUnit.unit A ≅ (constantSheaf J_punit).obj A`
on PUnit. The current sketch does not name or address this sub-step.

**Action**: Insert a sub-lemma block immediately after
`lem:skyscraperSheaf_eq_pushforward` (just before any later block) of
the form:

```latex
\begin{lemma}[Inner iso: skyscraperSheaf vs. constantSheaf on PUnit]
  \label{lem:skyscraperSheaf_iso_constantSheaf_punit}
  \lean{AlgebraicGeometry.Scheme.skyscraperSheaf_iso_constantSheaf_punit}
  ...
\end{lemma}
\begin{proof}
  \uses{...}
  Statement (in project notation):
    \(\skyscraperSheaf\,(\PUnit.\unit)\,A \cong (\text{constantSheaf}\,J_{\PUnit})_*\,A\)
  in the category of sheaves on PUnit valued in
  \(\text{ModuleCat}_{\bar k}\).
  Sketch:
    - The forward map: apply the constant-sheaf adjunction
      \(\text{constantSheafAdj}_{J_{\PUnit}}\,\text{ModuleCat}_{\bar k}\,h_{T\top}\)
      \(.\text{homEquiv}.\text{symm}\) to the natural identification
      \(\text{skyscraperSheaf}\,(\PUnit.\unit)\,A.\val.\obj\,(\op\,\top) = A\)
      (via `simp [skyscraperPresheaf]`, since `PUnit.unit ∈ ⊤`).
    - The inverse map: build pointwise on the two opens \(\bot, \top\)
      of PUnit:
        * at \(\op\,\bot\): both sheaves give the terminal object in
          ModuleCat, so use `IsTerminal.uniqueUpToIso`;
        * at \(\op\,\top\): use the constantSheaf-unit-iso on PUnit,
          which is true since the constantSheaf functor is fully
          faithful on PUnit (this Full/Faithful instance is the
          Mathlib gap; project must add it).
    - Naturality on \(\bot \le \top\): discharge by `Subsingleton`-of-
      terminal.
  Mathlib gap (route choice):
    - Route A: provide `(constantSheaf (Opens.grothendieckTopology PUnit) D).Full`
      and `.Faithful` instances (likely Mathlib upstreaming
      candidate; smallest project-side change).
    - Route B: directly construct the iso pointwise on the two opens
      of PUnit (~50-80 LOC standalone, no Mathlib upstream).
\end{proof}
```

Pin the `\lean{...}` to `AlgebraicGeometry.Scheme.skyscraperSheaf_iso_constantSheaf_punit`
(this declaration does NOT yet exist in Lean — the iter-197+ prover
will create it as a typed substrate helper, and the existing
`skyscraperSheaf_eq_pushforward_const` will then consume it,
eliminating the inner sorry).

Update `lem:skyscraperSheaf_eq_pushforward`'s `\uses{...}` block to
reference `lem:skyscraperSheaf_iso_constantSheaf_punit`.

### Major (also fix this iter):

### J-1. Stale `\uses{...}` on `lem:skyscraperSheaf_isFlasque`

**Current state**: `lem:skyscraperSheaf_isFlasque`'s `\uses{...}` lists
`lem:skyscraperSheaf_eq_pushforward`, `lem:isFlasque_constant_irreducible`,
`lem:isFlasque_pushforward`. The Lean proof at H1Vanishing.lean:903-939
does NOT use any of these — it goes directly via `skyscraperPresheaf_map`
on a P.point∈V case split.

**Action**: Update `\uses{...}` on `lem:skyscraperSheaf_isFlasque` to
list only the dependencies the Lean proof actually uses (`def:isFlasque_sheaf`,
the `IsFlasque` predicate). Remove the three stale entries. Add a
brief `% NOTE:` in the proof block noting that the Lean proof took a
direct route different from the four-lemma chain originally planned
in the blueprint.

### J-2. Add `\lean{...}` pin for `IsFlasque.injective_flasque`

**Current state**: `IsFlasque.injective_flasque` (Lean L613, full sorry)
is the transitive blocker for `HModule_flasque_eq_zero`. The chapter
prose references "the injective object I is flasque by Hartshorne III
Lemma 2.4" but has no `\lean{...}` pin so `sync_leanok` cannot track
it.

**Action**: Add a `\begin{lemma}` block immediately before
`thm:H1_vanishing_flasque` of the form:

```latex
\begin{lemma}[injective objects of $\Sh(X, \Mod_{\bar k})$ are flasque]
  \label{lem:isFlasque_injective}
  \lean{AlgebraicGeometry.Scheme.IsFlasque.injective_flasque}
  Let \(I\) be an injective object of
  \(\Sh(X, \text{ModuleCat}_{\bar k})\). Then \(I\) is flasque.
  % SOURCE: Hartshorne, Algebraic Geometry, Lemma III.2.4, p.207
  %         (read from references/hartshorne.pdf when present)
  \textit{Source: Hartshorne, AG III.2.4.}
  ...
\end{lemma}
\begin{proof}
  \uses{lem:isFlasque_pushforward, def:isFlasque_sheaf}
  Out-of-loop iter-196 directive (excluded from Lane H scope per
  progress-critic scope reduction): closure requires
  Mathlib's `j_!` extension-by-zero functor (the open-immersion
  pushforward-with-compact-support adjoint). Mathlib `b80f227` does
  not ship this functor in the sheaf-of-modules generality the lemma
  needs. Estimated closure cost: ~100-150 LOC project-side `j_!`
  scaffolding OR a Mathlib upstream PR.
\end{proof}
```

This makes the substrate gap **visible to `sync_leanok`** and to the
review tools. The block should NOT include a `% SOURCE QUOTE:` since
the project does not have Hartshorne's text locally — leave the
citation pointer only.

### J-3. Update `thm:H1_vanishing_flasque` `\uses{...}`

After the J-2 block lands, update `thm:H1_vanishing_flasque`'s
`\uses{...}` to include `lem:isFlasque_injective` explicitly. This
makes the dependency graph honest.

## Required content shape

- Total chapter LOC growth: ≤ ~120 LOC (M-1 note ~15 LOC, M-2 note
  ~10 LOC, M-3 sub-lemma block ~50 LOC, J-1 update ~5 LOC, J-2 block
  ~30 LOC, J-3 update ~5 LOC).
- All new `\lean{...}` pins reference fully-qualified Lean names that
  either ALREADY exist in Lean OR are clearly marked as future
  substrate targets (the future targets are `\lean{...}` pins on the
  block — the actual Lean declarations will be authored by the
  iter-197+ prover, NOT by you).
- Do NOT add `\leanok` or `\mathlibok` markers anywhere — those are
  managed by `sync_leanok` and the review agent. Your edits land
  unmarked or with `% NOTE:` commentary only.
- Do NOT touch any other chapter; this is a single-chapter directive.

## References

Lean file: `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
Reviewer report: `task_results/lean-vs-blueprint-checker-h1v.md`
Standing prover task report: `task_results/H1Vanishing.lean.md`

## Out of scope

- The `Scheme.IsFlasque.injective_flasque` Lean closure itself is
  off-critical-path (Mathlib `j_!` gap). Do NOT attempt to write a
  closure recipe; the iter-196 scope reduction stands.
- No changes to `lem:isFlasque_pushforward`, `def:isFlasque_sheaf`,
  `lem:flasque_cokernel_short_exact`, `lem:ext_succ_zero_of_injective_lower_zero`,
  `lem:closedPoint_closure_irreducible`, `thm:H1_vanishing_flasque`
  (proof body), `lem:H1_skyscraperSheaf_finrank_eq_zero_main` —
  those are axiom-clean and the lean-vs-blueprint-checker reports them
  as accurate.
- No changes to existing `\leanok` markers (would be a violation of
  the writer descriptor).

## Verification (for you, the writer)

After your edits land:
- Confirm the file compiles in LaTeX (no unclosed environments / bad
  refs). Run `cd blueprint && lake env latex print blueprint || true`
  to test, or just visually inspect.
- Confirm every `\lean{...}` you added or modified resolves to an
  existing Lean declaration OR is clearly marked as a future
  substrate target in the block's `% NOTE:`.
- Confirm the new sub-lemma `lem:skyscraperSheaf_iso_constantSheaf_punit`
  is referenced from `lem:skyscraperSheaf_eq_pushforward`'s `\uses{...}`.

Report in `task_results/blueprint-writer-h1v-mustfix-iter197.md`:
- 1-paragraph summary of what changed
- List of must-fix items addressed (M-1, M-2, M-3, J-1, J-2, J-3)
- Any strategy-modifying findings (don't add them as edits; flag and
  return for the planner to handle)
