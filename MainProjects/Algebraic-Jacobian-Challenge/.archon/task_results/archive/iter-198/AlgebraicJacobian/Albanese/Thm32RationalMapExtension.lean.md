# AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean

## Summary

- Declarations added (axiom-clean): **0**.
- Declarations blocked: **1** (`isReduced_of_smooth_over_field`).
- Sorry count: **2 → 2** (unchanged).
  - L151/155 `isReduced_of_smooth_over_field` (the HARD BAR target this iter).
  - L244/294 `av_codimOneFree_of_indeterminacy` branch 2 (gated on Lane COE
    Stage 6 outcome — out of scope this iter per the directive).

The HARD BAR ("close L155 axiom-clean") was not met. The supposed
30–80 LOC recipe in PROGRESS.md ("smooth ⟹ formally smooth + geom-reduced
⟹ reduced; Mathlib gradient: verify `Algebra.IsSmooth.isReduced` else
build") does not match Mathlib b80f227's actual API: the bridge
**FormallySmooth ⟹ IsGeometricallyReduced** is not present in
Mathlib, and constructing it requires substantial new infrastructure
(Stacks 00TF / 0398 chain) well outside the iter budget.

## isReduced_of_smooth_over_field (L151 — NOT CLOSED)

- **Goal**: `[Field kbar] (A : Over (Spec (.of kbar))) [Smooth A.hom] ⊢ IsReduced A.left`.
- **Approach 1 — direct Mathlib lookup**: searched for
  - `AlgebraicGeometry.Smooth → IsReduced` (any direction): **none found**.
  - `Algebra.Smooth K A → IsReduced A` (K a field): **none found**.
  - `Algebra.IsStandardSmooth K A → IsReduced A` (K a field): **none found**.
  - `Algebra.FormallySmooth K A → IsGeometricallyReduced K A`: **none found**.
  - `IsRegularLocalRing R → IsDomain R` (or `→ IsReduced R`): **none found**.
  - `Algebra.FormallyUnramified.isReduced_of_field` exists but requires
    `FormallyUnramified` (not Smooth — Smooth is strictly weaker on the
    differential side).
  - `Algebra.isReduced_of_isGeometricallyReduced` exists but requires the
    `IsGeometricallyReduced` instance, which we cannot supply.
  - **VERDICT**: no direct Mathlib lemma covers smooth ⟹ reduced over a
    field at any of (scheme, algebra, formally-smooth) granularity.

- **Approach 2 — affine-cover route**:
  By `Smooth.iff_forall_exists_isStandardSmooth`, for each `x : A.left`
  there exist affine opens `U` of `Spec kbar` and `V ∋ x` of `A.left`
  with `(A.hom.appLE U V e).hom.IsStandardSmooth`, giving
  `Algebra.IsStandardSmooth kbar Γ(A.left, V)`.
  Then by `IsReduced.of_openCover` + `affine_isReduced_iff`, it would
  suffice to prove `IsReduced Γ(V)` from `Algebra.IsStandardSmooth kbar Γ(V)`.
  Mathlib's `Algebra.IsStandardSmooth` only ships `Algebra.Smooth` and
  `Algebra.FormallySmooth` as downstream conclusions; no isReduced bridge.
  **FAILED**: same Mathlib gap as Approach 1, just at the algebra layer.

- **Approach 3 — stalk-level route**:
  By `isReduced_of_isReduced_stalk`, it would suffice that every stalk is
  reduced. The project's `isRegularLocalRing_stalk_of_smooth` (in
  `Albanese/CodimOneExtension.lean`, L544) intends to show stalks are
  `IsRegularLocalRing` for smooth morphisms — but (a) it is **itself
  `sorry` at Stage 6** (Stacks 02JK + 00OE gaps documented at L590+
  and tracked as Lane COE; see PROGRESS.md priority-2), AND (b) it takes
  `[IsReduced X.left]` as a hypothesis already, defeating the purpose.
  Even if Lane COE Stage 6 closes upstream, the regular-local-ring ⟹
  domain ⟹ reduced chain also needs a Mathlib bridge that does not
  presently exist (loogled `IsRegularLocalRing, IsDomain`: no hits).
  **FAILED**: doubly-gated on Lane COE Stage 6 closure + a separate
  `IsRegularLocalRing → IsReduced` bridge.

- **Approach 4 — IsAlgClosed shortcut via IsGeometricallyReduced**:
  Add `[IsAlgClosed kbar]` (matches the unique call site
  `av_isIntegral_of_smooth_geomIrred`). Use
  `Algebra.isGeometricallyReduced_iff`:
  `IsGeometricallyReduced kbar A ↔ IsReduced (AlgebraicClosure kbar ⊗[kbar] A)`.
  Since kbar is already algebraically closed,
  `AlgebraicClosure kbar ≃+* kbar`, so this reduces to
  `IsReduced (kbar ⊗[kbar] A) ⇔ IsReduced A`. **Circular**: collapses to
  the original goal without ever using the smooth hypothesis. FAILED.

- **Approach 5 — informal agent**:
  Attempted to dispatch with `--provider kimi`. The configured
  `MOONSHOT_API_KEY` returns HTTP 401 "Invalid Authentication" against
  `https://api.kimi.com/coding/`. No DeepSeek / OpenAI / OpenRouter /
  Gemini keys are present in env. **FAILED** (provider key invalid).

- **Verdict**: NOT ADDED. The current `sorry` body is the correct
  layering — it isolates a single Stacks 034V / 02G4 bridge into a
  single named declaration (per lean-auditor iter-196 must-fix). The
  body is unchanged from iter-197 because there is no axiom-clean path
  in Mathlib b80f227. The recipe in PROGRESS.md ("Mathlib gradient:
  verify `Algebra.IsSmooth.isReduced` else build") underestimates the
  build cost — building `Algebra.FormallySmooth K A → IsGeometricallyReduced K A`
  requires Stacks 00TF (smooth k-algebra is geometrically regular),
  itself ~200+ LOC over Mathlib of cotangent / Kähler infrastructure
  that overlaps Lane COE's Stage 6 expansion.

- **Next-iter recommendation**: re-classify this as a Lane COE
  derivative. Once Lane COE Stage 6.A (`smooth_algebra_krull_dim_formula`)
  + 6.B (`cotangent_kahler_over_field`) lands per the iter-198 plan
  (`isRegularLocalRing_stalk_of_smooth` axiom-clean), package a small
  helper `IsRegularLocalRing.isDomain` (~10–30 LOC; Stacks 00NP) and
  derive `isReduced_of_smooth_over_field` via stalk-localisation +
  `isReduced_of_isReduced_stalk`. Estimate: ~60 LOC after COE Stage 6
  closes; ~300 LOC if attempted cold. **DO NOT** dispatch this lane
  again until COE Stage 6 reports `done`.

## av_codimOneFree_of_indeterminacy (L244, branch 2 — NOT in scope this iter)

- **Status**: branch 2 (the pure-codim-1 disjunct) `sorry` at L294 is
  gated on Lane COE exposing
  `indeterminacy_codimGe2_of_smooth_of_complete` as a standalone lemma
  (currently encapsulated inside `extend_of_codimOneFree_of_smooth`'s
  body, which is itself `sorry` in `Albanese/CodimOneExtension.lean`).
  PROGRESS.md explicitly defers this to "iter-199+" gated on Lane COE
  closure: "L294 is gated on Lane COE Stage 6 outcome".
- **Action**: untouched, per directive scope ("do NOT touch L294").

## Why I stopped

**Blocked — alternatives exhausted.** All five attempted approaches
(direct Mathlib lookup, affine-cover, stalk-route, IsAlgClosed
shortcut, informal-agent) failed for documented reasons:

1. No `Smooth → IsReduced` lemma exists in Mathlib b80f227 at any
   granularity (scheme, algebra, formally-smooth) — verified by
   `lean_leansearch` / `lean_loogle` / repository grep
   (`Algebra.IsGeometricallyReduced` is only referenced in its own
   defining file).
2. The stalk-route is blocked by Lane COE Stage 6 (itself the priority-2
   target this iter) AND by a separate missing
   `IsRegularLocalRing → IsDomain` bridge.
3. The recipe in PROGRESS.md (30–80 LOC) underestimates the actual cost
   by an order of magnitude.
4. No usable informal-agent key (Moonshot returns 401).
5. The existing `sorry` is already optimally isolated (single named
   declaration, exhaustive docstring per lean-auditor iter-196 must-fix).

The HARD BAR ("close L155 axiom-clean") is **not achievable as a
self-contained iter target** — it is functionally a Lane COE derivative
and should be re-routed accordingly. Final file state: no new
declarations, no new sorries, no churn.

## Blueprint marker hints (for review agent / sync_leanok)

- `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}` at
  `chapters/Albanese_Thm32RationalMapExtension.tex` L52: **still
  `sorry`-backed** (cascade gated on L155 + L294). Do NOT add `\leanok`
  to its `theorem` block this iter — sync_leanok will handle the
  removal/preservation deterministically.
- No semantic marker changes recommended this iter.
