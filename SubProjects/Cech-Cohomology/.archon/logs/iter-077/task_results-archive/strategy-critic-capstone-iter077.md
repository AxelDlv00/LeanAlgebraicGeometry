# Strategy Critic Report

## Slug
capstone-iter077

## Iteration
077

## Routes audited

### Route: A — acyclic-resolution comparison (the P5b capstone, ACTIVE)

- **Goal-alignment**: FAIL — the route's ingredients close `Hⁱ(f_*C•) ≅ Rⁱf_*F` **only for an
  affine cover of a separated `X`**, but the frozen goal quantifies over an arbitrary finite
  `𝒰 : X.OpenCover` with no affineness and no `X.IsSeparated`. The route cannot produce the goal
  *as the frozen signature states it*.
- **Mathematical soundness**: PASS (conditionally) — the abstract argument (apply P4
  `rightDerivedIsoOfAcyclicResolution` with `G = f_*`, `K = cechComplexOnX`, resolution data from
  `cechAugmented_exact`, termwise acyclicity from the open-immersion `_acyclic`/`_comp` chain, then
  the seam isos) is correct **provided the cover members and all finite intersections are affine and
  `X` is separated**. The decomposition steps (i)–(iv) are individually sound under that proviso.
- **Phantom prerequisites**: none phantom — but two *required* prerequisites are **unavailable in the
  frozen context** (see Must-fix). `(pushforward f).Additive` is present
  (`OpenImmersionPushforward.lean:788`); `[PreservesFiniteLimits (pushforward f)]` follows from
  `pushforward` being a right adjoint (low risk, but must actually be wired as an instance — verify,
  don't assume).
- **Effort honesty**: under-counted in *scope*, not LOC — the `~150–350 LOC / ~2–3 iters` cell omits
  the unbridgeable-hypothesis problem entirely. No LOC estimate closes a hole that requires amending a
  frozen signature.
- **Verdict**: CHALLENGE (escalating toward REJECT) — proceed on P5b **only after** the signature gap
  below is resolved by the mathematician; the assembly cannot type-check otherwise.

### Route: SS — two spectral sequences (REJECTED)
- **Verdict**: SOUND (correctly excised; rests on absent multi-kLOC Mathlib infra). No action.

### Route: the acyclicity bridge / `cechAugmented_exact` sections route / Absolute cohomology Form B
- **Verdict**: SOUND — these are the completed/supporting bricks feeding Route A; their internal math
  is consistent with the `## Completed` ledger and references. The single project-level defect is
  not in any of them individually but in whether their *hypotheses can be supplied at the frozen
  call-site* (Route A, above).

## Format compliance

- **Size**: 145 lines / 18 879 bytes — **over budget** (~12 KB ceiling; 18.4 KB).
- **Headings**: PASS — `## Goal`, `## Phases & estimations`, `## Completed`, `## Routes`,
  `## Open strategic questions`, `## Mathlib gaps & new material`, in canonical order.
- **Per-iter narrative detected**: yes (mild) — the active Phases row embeds dated narrative
  (`RELOCATION (iter-077): …`, `φ'' billed ~40–80 LOC was a DEFEQ (4 wasted iters 061–063)` in the
  Completed `Pitfalls` cells). The Completed-table iter tags are fine; the inline `(iter-077)` /
  "wasted iters" phrasing in cells is per-iter narrative that belongs in `iter/iter-NNN/plan.md`.
- **Accumulation detected**: no completed phase is stranded in the active table (only the P5b row is
  active). But the single active row carries a **multi-paragraph cell** (the `Key Mathlib needs`
  cell is ~12 lines of prose with an embedded RELOCATION sub-decision).
- **Table discipline**: FAIL (mild) — the active `## Phases & estimations` row violates "one short
  line per cell"; the relocation decision and the (i)–(iv) decomposition should be a `## Routes`
  sub-bullet, not a table cell.
- **Format verdict**: DRIFTED — restructure the active row to one-line cells and push the byte count
  back under 12 KB this iter; not blocking, but compounding.

## Must-fix-this-iter

- **Route A: CHALLENGE — fatal hypothesis gap at the frozen call-site.** Every ingredient of the P5b
  assembly demands hypotheses the frozen signature does not provide:
  - `cechAugmented_exact` (P5a) is `(h𝒰 : ∀ i, IsAffine (𝒰.X i)) [X.IsSeparated] … (hF)`.
  - `cechTerm_pushforward_acyclic` (item i) is built on `higherDirectImage_openImmersion_acyclic`
    (`OpenImmersionPushforward.lean:805`), which carries **`[IsAffine U] [X.IsSeparated]`**, and on
    `isAffineHom_of_affine_separated` (`:763`), which needs the same.
  - The frozen signature supplies only `(f : X ⟶ S) [QuasiCompact f] [IsSeparated f]
    (𝒰 : X.OpenCover) [Finite 𝒰.I₀]`. **`X.OpenCover` is the general (non-affine) cover** — the
    project's own Mathlib has a *separate* `AffineOpenCover`
    (`Mathlib/AlgebraicGeometry/Cover/Open.lean`). And `[IsSeparated f]` (separatedness of the
    *morphism*) does **not** give `[X.IsSeparated]` (absolute separatedness of `X`) for arbitrary
    `S`; nor does anything give `IsAffine (𝒰.X i)`.

  Consequence: the planner cannot discharge `[∀ n, (pushforward f).IsRightAcyclic
  ((cechComplexOnX 𝒰 F).X n)]` — the central instance argument of `rightDerivedIsoOfAcyclicResolution`
  — from the frozen context. This is not a missing lemma; it is a **statement that is false for general
  finite covers**. Concrete refutation: take `X = ℙ¹_k`, `S = Spec k`, `f` proper (so separated +
  quasi-compact), `F = O(-2)`, and `𝒰` the **single-element cover `{𝟙 X}`** (finite, valid
  `OpenCover`, member `X` not affine). Then `cechComplexOnX` is the constant cosimplicial object, its
  alternating-coface homology gives `Hⁱ(CechComplex) = 0` for `i ≥ 1`, while
  `R¹f_*O(-2) = H¹(ℙ¹,O(-2)) ≠ 0`. So `Nonempty (… ≅ …)` is false, independent of how the proof is
  organized. (Vacuity of `[HasInjectiveResolutions X.Modules]` does not rescue provability: the proof
  must construct the iso from an abstract instance, and the term-acyclicity obstruction is present
  abstractly.)

  **Required planner action this iter:** do NOT open a P5b assembly prover lane against the current
  signature. Surface to the mathematician (via `TO_USER.md`, and request a `USER_HINTS.md` decision)
  that `cech_computes_higherDirectImage` needs its hypotheses strengthened to match Stacks 02KE — at
  minimum add `(h𝒰 : ∀ i, IsAffine (𝒰.X i))` and either `[X.IsSeparated]` or `[IsSeparated S]`
  (equivalently restrict `𝒰` to `X.AffineOpenCover` and/or require affine intersections). Only the
  mathematician may edit the frozen signature; the planner must either (a) record an explicit rebuttal
  in `plan.md` if it believes the hypotheses are derivable (they are not — show the derivation or
  retract), or (b) pause P5b pending the signature amendment. Relocation work (below) may proceed in
  parallel since it is signature-preserving.

- **Format: DRIFTED** — collapse the active Phases-table row to one-line cells (move the (i)–(iv)
  decomposition and RELOCATION note into a `## Routes` Route-A sub-bullet) and trim inline
  `(iter-0NN)` narrative from table cells; bring the file back under 12 KB.

## Overall verdict

Route A's abstract mathematics is sound — for an **affine** cover of a **separated** `X` the P4
acyclic-resolution lemma plus `cechAugmented_exact` plus the open-immersion acyclicity chain does give
`Hⁱ(f_*C•) ≅ Rⁱf_*F`, and the relocation decision (Question 2) is **structurally correct and SOUND**:
the frozen theorem sits upstream of every ingredient, every ingredient genuinely imports the object
layer, so moving the theorem verbatim to a downstream leaf with the YAML path updated is the only
non-cyclic option and is explicitly permitted for a structural subagent. Relocation is fine.

But the assembly **cannot close the frozen signature as currently stated**: the strategy assumes
affineness of the cover members and separatedness of `X` reach the call-site through
`[QuasiCompact f][IsSeparated f]`, and they do not — `X.OpenCover` is the general cover, `[IsSeparated f]`
is morphism-separatedness, and there is a single-element-cover counterexample making the goal literally
false for arbitrary finite covers. Both `cechAugmented_exact` and `cechTerm_pushforward_acyclic` carry
`IsAffine`/`X.IsSeparated` hypotheses with no source in the frozen context. The strategy defers this gap
to a passing remark ("the cover-affine `h𝒰`/`IsSeparated` hyps reaching the frozen signature") instead
of resolving it; **that gap is required for the stated goal and no route in the strategy bridges it**,
because no route *can* — it is a property of the frozen signature, which only the mathematician may
amend. The capstone is not "every ingredient ready, assemble"; it is blocked on a signature that is too
strong. Resolve the signature before any P5b prover dispatch.
