# Mathlib Analogist Report — M3 Route A audit refresh

## Slug

m3-route-a-refresh-iter145

## Iteration

145

## Question

Refresh the iter-123 Route A LOC audit (`analogies/m3-route-audit.md`)
against the current Mathlib snapshot. Re-price A1 (Hilbert / QCoh /
Coh / flattening, iter-123 ~4150 LOC), A2 (Quot post-A1, iter-123
~1400 LOC), A3 (identity-component subgroup scheme, iter-123 ~1025 LOC).

## Snapshot used

- **Project pin** (`lake-manifest.json:30-31`): `b80f227`.
  **UNCHANGED from iter-123.**
- **Mainline mainline** (per GitHub directory listing iter-145): only
  `Birational/` directory + `RationalMap.lean` reorganisation; **no
  movement on Hilbert / Quot / Picard scheme / `Coherent` / flattening
  / identity-component on schemes since `b80f227`**.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| A1 (Hilbert + QCoh + Coh + flattening) refresh | AUDIT_STABLE (−9% midpoint) | informational |
| A2 (Quot post-A1) refresh | AUDIT_STABLE (−6% midpoint) | informational |
| A3 (identity-component) refresh | AUDIT_STABLE (−5% midpoint) | informational |
| Iter-123 audit inventory accuracy | ALIGN_WITH_HISTORICAL_FACT | critical (correction) |

The "AUDIT_*" verdicts mirror the directive's verdict scale. The
"ALIGN_WITH_HISTORICAL_FACT" entry is the report's correction of an
iter-123 inventory error (see Must-fix #1 below).

## Refreshed numbers

| Piece | iter-123 range | iter-145 range | iter-123 midpoint | iter-145 midpoint | Delta on midpoint |
|---|---|---|---|---|---|
| A1 | 3400–4900 | 3030–4520 | 4150 | 3775 | −375 (−9%) |
| A2 | 1100–1700 | 1020–1620 | 1400 | 1320 | −80 (−6%) |
| A3 | 850–1200 | 810–1140 | 1025 | 975 | −50 (−5%) |
| **Route A total** | **5350–7800** | **4860–7280** | **~6500** | **~6070** | **−430 (−7%)** |

Per-sub-piece tables, citations for every "landed" item, and the
itemisation of what is "still missing" are in
`analogies/m3-route-a-refresh-iter145.md`.

## Must-fix-this-iter

1. **Iter-123 audit inventory error: `IsQuasicoherent` typeclass on
   `SheafOfModules` IS present in `b80f227`.** Iter-123 audit line 79
   asserted "it is not lifted to a typeclass `QuasiCoherent` /
   `IsCoherent` on `SheafOfModules` in the form Stacks 03DL or 01BD
   specify". This is inaccurate: `class IsQuasicoherent (M :
   SheafOfModules R) : Prop` exists at
   `Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent:249`, with
   `class IsFinitePresentation (M : SheafOfModules R) : Prop` at
   same file:262, the closed-under-iso `ObjectProperty` instance at
   line 330, and the local-characterisation lemma
   `IsQuasicoherent.of_coversTop` at line 377. The remaining A1.1 work
   is the *scheme-side specialisation* (`Scheme.QuasiCoherent X` wrapper
   ~80–120 LOC) + the *affine-Tilde calibration* (~150–200 LOC), not
   the typeclass itself. Refreshed A1.1 LOC: ~230–320, down from
   iter-123's ~400–500. The iter-123 audit's persistent file should
   be read with this correction (the iter-145 refresh file captures
   it; the iter-123 file is preserved verbatim for audit history).

2. **`IsLocallyNoetherian` / `IsNoetherian` typeclasses on `Scheme`
   were not credited by iter-123.** These exist at
   `Mathlib.AlgebraicGeometry.Noetherian:57,278` and are the
   Noetherian-base prerequisite Stacks 01XZ relies on for the
   coherent ⇔ qcoh+finite-presentation equivalence. They reduce
   A1.2 from ~300–400 LOC to ~150–250 LOC.

## Major

(No fresh ALIGN_WITH_MATHLIB verdicts; this is an audit-refresh
dispatch, not a design-decision dispatch.)

## Informational

3. **Mainline Mathlib has NOT moved on the gating Route A sub-pieces
   since `b80f227`.** Verified at iter-145: mainline AG directory has
   `AlgClosed`, `Birational`, `Cover`, `EllipticCurve`, `Geometrically`,
   `Group`, `IdealSheaf`, `Modules`, `Morphisms`, `ProjectiveSpectrum`,
   `Sites` subdirectories. Group/ contains only `Abelian.lean` +
   `Smooth.lean` (no `IdentityComponent.lean`, no `Connected.lean`,
   no `Subgroup.lean`). Sites/ contains no `Hilbert.lean` /
   `Quot.lean` / `Picard.lean`. No `HilbertScheme` / `HilbertFunctor`
   / `QuotScheme` / `QuotFunctor` / `PicardScheme` /
   `FlatteningStratification` matches anywhere in `Mathlib/`. **The
   ~1500–2200 LOC A1.5 flattening-stratification piece — the single
   largest Route A item — shows zero upstream activity.** Multi-year
   wall-clock implication of the iter-144 commitment is unchanged.

4. **The directive's wording "Hilbert scheme representability for
   projective schemes (`Mathlib.AlgebraicGeometry.Hilbert.Representability`
   — did NOT exist iter-123)" was understood as a candidate location
   to check for landing.** It has NOT landed at that path or anywhere
   else as of iter-145. Same for the directive's QCoh / Coh
   "flattening stratification (Grothendieck) — did NOT exist iter-123
   in mainline" candidate; still absent in mainline iter-145.

5. **Smallest-LOC A1 entry recommendation**: the cheapest in-tree
   entry into Route A under iter-145's landscape is `Scheme`-side
   `IsQuasicoherent X` specialisation + affine-Tilde calibration
   (~230–320 LOC, A1.1) — strictly less than the iter-123 estimate
   for the same piece because the bundled typeclass already exists.
   This supersedes iter-123's smallest-PR-extractable recommendation
   list (which still applies for STRATEGY.md L638's `RelativeSpec`
   on its own merits).

6. **Verification methodology used.**
   - `lake-manifest.json` direct read (pin confirmation).
   - `Grep` on `Mathlib/AlgebraicGeometry/` for `HilbertScheme`,
     `HilbertFunctor`, `QuotScheme`, `QuotFunctor`, `PicardScheme`,
     `PicardFunctor`, `QuasiCoherent`, `IsCoherent`,
     `FlatteningStratification`, `Flattening`,
     `connectedComponentOfOne`, `identityComponent`,
     `IdentityComponent`.
   - `Grep` on `Mathlib/` for Stacks tags `03DL`, `01BD`, `052F`,
     `0BFR`, `0DPA`, `0DPB`, `03GX` (zero matches — no formalisation
     of the load-bearing Stacks theorems).
   - `Glob` on `Mathlib/AlgebraicGeometry/` for `Modules/*.lean` and
     `Group/*.lean` (confirmed the same 3 + 2 files iter-123 listed).
   - Direct file survey on
     `Mathlib.Algebra.Category.ModuleCat.Sheaf.Quasicoherent` (386
     LOC) and `Mathlib.AlgebraicGeometry.Noetherian` (lines 57–361).
   - WebFetch on mainline `Mathlib/AlgebraicGeometry/` and
     `Mathlib/AlgebraicGeometry/Group/` directory listings to
     confirm no mainline drops since `b80f227`.

## Persistent file

- `analogies/m3-route-a-refresh-iter145.md` — refreshed per-piece LOC
  tables, citations for every landed / still-missing sub-piece, and
  the planner-facing recommendation.

## Overall verdict

**AUDIT_STABLE.** Route A midpoint moves from ~6500 LOC (iter-123) to
~6070 LOC (iter-145) — a −7% midpoint refresh, with every sub-piece
delta within ±20%. The bulk of the refresh delta is iter-123 inventory
undercount (it missed the `IsQuasicoherent` / `IsFinitePresentation`
typeclasses on `SheafOfModules` and the `IsLocallyNoetherian` /
`IsNoetherian` typeclasses on `Scheme` already present in `b80f227`),
not Mathlib motion since iter-123. Mainline progress on the gating
sub-pieces (Hilbert / Quot / `Coherent` / flattening / identity-
component on schemes) is zero. The iter-144 Route A commitment is
preserved on these numbers; STRATEGY.md L627 sunk-cost guardrail is
honored. Recommend re-refresh at iter-170 (matching the iter-123 →
iter-145 cadence), or earlier if any of the absent gating files lands
in mainline.
