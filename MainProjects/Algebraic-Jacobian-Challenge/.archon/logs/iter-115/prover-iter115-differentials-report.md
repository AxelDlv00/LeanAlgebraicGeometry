# AlgebraicJacobian/Differentials.lean

## Status: INCOMPLETE (per iter-115 hard rules)

**Bar A**: NOT MET (L175's `sorry` not closed; file sorry count 5 → 5).
**Bar B**: NOT MET (no recipe step closed as a new top-level sound-signature
sub-helper; the existing `relativeDifferentialsPresheaf_obj_kaehler` at L90 was
the only sound Step-1-adjacent helper, and it predates this iter).
**Bar C**: NOT TRIGGERED — no new sorry-bodied reformulation wrapper was
introduced. The session deliberately stopped short of spawning another
sub-helper per the progress-critic-iter115 primary corrective.

## Substantive changes this iter

### 1. Docstring rewrite at `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` (the iter-115 mandatory pre-step)

The iter-113 recipe at the lemma's docstring was **mathematically wrong** (Step 1
"project compatible Ω-families to compatible O_X-families via the universal
derivation `d`" — `d` is a multilinear derivation, not invertible). Replaced
with the iter-114 mathlib-analogist-verified 3-step recipe from
`blueprint/src/chapters/Differentials.tex` § "Unique-gluing form":

1. **Affine-basis identification** via `KaehlerDifferential.isLocalizedModule`
   [verified, **no `_map` suffix** — iter-115 naming correction] +
   `AlgebraicGeometry.tilde` [verified, **namespace `AlgebraicGeometry`, not
   `AlgebraicGeometry.Modules`** — iter-115 naming correction]
   (`Mathlib.AlgebraicGeometry.Modules.Tilde`).
2. **Hand-rolled cofinality descent** (the basis-to-X bridge is genuinely
   missing from Mathlib b80f227; verified by mathlib-analogist-iter114,
   persistent file `analogies/affine-basis-sheaf-bridge.md`). Anchored on
   `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover` [verified] +
   `TopCat.Presheaf.isSheaf_iff_isSheafUniqueGluing_types` [verified].
3. **Uniqueness** via `TopCat.Presheaf.Sheaf.eq_of_locally_eq` [verified]
   reduced through `KaehlerDifferential.span_range_derivation` [verified].

The two naming corrections flagged by the iter-115 plan-phase
re-verification are propagated into the docstring (chapter prose carried
the older `_map`-suffix / `AlgebraicGeometry.Modules.tilde` forms).

### 2. Structural opening of the proof body

The proof body now begins with `intro ι U sf hcomp`, exposing the existential
+ uniqueness goal
```
⊢ ∃! s, TopCat.Presheaf.IsGluing F U sf s
```
explicitly to the next prover. This is a non-displacing structural
advance — no new sub-helper or wrapper is introduced, the `sorry`
remains inline at the use-site (per the iter-115 Soundness rule), and an
extended comment block at the sorry pin-points exactly which recipe-step
the next round must construct (Step 2's hand-rolled cofinality descent
is the load-bearing missing piece).

## What did NOT happen and why

Pursuant to the iter-115 progress-critic primary corrective and the iter-116
hard gate committed in `iter/iter-115/plan.md`:

- **No additional sorry-bodied sub-helper was introduced.** The Step 2
  basis-to-X bridge is hand-rolled inline; the analogist confirmed no
  off-the-shelf Mathlib bridge exists. Spinning out a wrapper-helper of
  the form `..._descent_type` would be the **third helper round** on this
  route — banned by the iter-115 hard rules.

- **No reformulation across equivalent sheaf conditions was attempted.** The
  iter-113 pivot from `IsSheafOpensLeCover` to `IsSheafUniqueGluing` was the
  reformulation pattern flagged by progress-critic-iter114/115; repeating
  that pattern at a deeper layer (e.g. pivoting to
  `IsSheafEqualizerProducts` or `IsSheafPairwiseIntersections`) would not
  advance the mathematical content.

- **No universally-false-signature helper was introduced.** Per the Soundness
  rule, the inline `sorry` is left at the use-site rather than displaced
  through a wrong-signature wrapper.

## Why Bar B was not achieved

The blueprint's 3-step recipe is **internally entangled** at the Mathlib
level: Step 2 (cofinality descent) and Step 3 (uniqueness via
`eq_of_locally_eq` on the structure sheaf, transferred through
`KaehlerDifferential.span_range_derivation`) both depend on Step 1's
affine-basis identification with `tilde Ω_{B/A}`. The identification
itself requires unpacking `relativeDifferentialsPresheaf`'s underlying
construction
(`PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`)
on each affine basic open `D(g) ⊆ Spec B`, which goes through the
inverse-image presheaf `f⁻¹ O_S` whose value on `D(g)` is a colimit that
must be shown to collapse to `O_S(f(D(g)).coarsest affine cover)`.

The Step-1 sound-signature helper would therefore have body comparable
in size to the entire recipe (no clean factoring point internal to the
ring-level Kähler-localisation correspondence). Closing Step 1 alone is
not a tractable single-prover-lane operation under the iter-115
soundness rule.

A Step-3 sound-signature helper (uniqueness only) is **circular against the
existing infrastructure**: `eq_of_locally_eq` requires `F` to be a sheaf,
which is what we're trying to prove. The Step-3 uniqueness statement
free-standing as a separation property of `F` would itself need the affine
identification.

A Step-2 sound-signature helper (cofinality descent) is precisely the
hand-rolled inline content that the iter-115 hard rules require to be
**built inline, not displaced via a sorry-bodied wrapper**.

Hence: no Bar B advance is possible without violating the iter-115
soundness / no-further-reformulation rules.

## Sorry inventory (post-session, unchanged)

| Line | Declaration | Status |
|---|---|---|
| L191 (was L175) | `relativeDifferentialsPresheaf_isSheafUniqueGluing_type` | iter-115 INCOMPLETE — `intro` + inline sorry; recipe annotated. |
| L737 (was L798) | `cotangentExactSeq_structure case h_exact` | OFF-LIMITS (named Mathlib gap #2). Untouched. |
| L931 (was L880) | `smooth_iff_locally_free_omega` | OFF-LIMITS (Phase B prover-viable, scheduled iter-117+). Untouched. |
| L947 (was L897) | `cotangent_at_section` | OFF-LIMITS (Phase B prover-viable, scheduled iter-118+). Untouched. |
| L1091 (was L1039) | `serre_duality_genus` | OFF-LIMITS (named Mathlib gap #7). Untouched. |

(Line shifts are entirely due to the docstring rewrite expanding the
documentation block above `_isSheafUniqueGluing_type`. Declaration
identities are unchanged.)

## Verification

- `python3 sorry_analyzer.py AlgebraicJacobian/Differentials.lean --format=summary` →
  **5 sorries** (same as entry).
- `python3 sorry_analyzer.py AlgebraicJacobian --format=summary` →
  **16 sorries** project-wide (same as entry).
- `lean_diagnostic_messages` severity=error on `AlgebraicJacobian/Differentials.lean` →
  `[]` (file compiles).
- Cosmetic warnings carried from entry: 2 `IsSmoothOfRelativeDimension`
  deprecations (L933 / L950 — were L875 / L892) + 1 line-length linter
  (L846 — was L788).
- No new `axiom` declarations introduced.
- `archon-protected.yaml` not modified.

## Blueprint markers (handoff to review agent)

- `\lem:relative_kaehler_isSheafUniqueGluing` — **leave `\leanok` on
  statement; do NOT add `\leanok` on proof** (still sorry-bodied). The
  deterministic `sync_leanok` phase between prover and review will
  enforce this.

## Recommendation for iter-116 (the hard-gate iter)

This session is the third consecutive PARTIAL/INCOMPLETE round on the L175
route (iter-113 introduced the `IsSheafUniqueGluing` pivot; iter-114 was
the deeper-think no-prover round; iter-115 is this round). The iter-116
hard gate committed in `iter/iter-115/plan.md` should now fire.

Concretely, the strategic options for iter-116+ are:

1. **Spawn a multi-iter campaign** dedicated to the Step-1 affine
   identification — likely 3–5 iters and several hundred LOC to build
   the per-affine-chart `tilde` identification.

2. **Pivot the framing** of `relativeDifferentials` to use
   `PresheafOfModules.sheafification` directly (analogist-rejected
   alternative; would convert the obligation from "prove F is a sheaf"
   to "prove sheafification-unit is iso on affine opens" — same
   mathematical work under a different name, but the obligation lives
   on a different Lean term).

3. **User-escalate** for prioritization — is this Phase B step
   load-bearing for the downstream Jacobian construction? If `Ω_{X/S}`
   only needs to exist as a sheaf for the cotangent-space-at-section
   argument (L897 `cotangent_at_section`), is there a thinner
   formalisation that bypasses the sheaf condition entirely?

The analogist's persistent file `analogies/affine-basis-sheaf-bridge.md`
already records the rejected alternative routes (sheafification,
tilde-glue-on-cover, IsDenseSubsite); each has the same underlying
obligation. The genuine missing piece in Mathlib b80f227 is the
basis-to-X bridge for `Scheme.PresheafOfModules`.

## Next-prover-session next steps (if iter-116 elects to continue the
campaign rather than escalate)

1. **Build the Step 1 affine identification as a top-level lemma** with
   signature shaped roughly as
   ```
   lemma relativeDifferentialsPresheaf_basicOpen_iso_tilde
       (f : X ⟶ S) (V : X.affineOpens) (W : S.affineOpens)
       (hf : f.base '' V ⊆ W) (g : Γ X V) :
     (relativeDifferentialsPresheaf f).presheaf.obj
         (Opposite.op (V.basicOpen g)) ≅
       (AlgebraicGeometry.tilde
         (CommRingCat.KaehlerDifferential ...)).val.obj
         (Opposite.op (V.basicOpen g)) := ...
   ```
   Body: route through `KaehlerDifferential.isLocalizedModule`. Expected
   200–300 LOC.

2. **Build the Step 2 cofinality descent inline** (no wrapper) — direct
   use of `TopCat.Presheaf.isSheaf_iff_isSheafOpensLeCover` on the
   refined cover plus a hand-rolled coherence transfer back to the
   original cover. Expected 150–200 LOC.

3. **Step 3 uniqueness** then collapses to applying the Step-1
   identification + Mathlib's `tilde`-`isSheaf` to extract
   `eq_of_locally_eq` on `Ω` directly.

## Developer feedback

(Skipped — no concrete observation rises above the bar.)
