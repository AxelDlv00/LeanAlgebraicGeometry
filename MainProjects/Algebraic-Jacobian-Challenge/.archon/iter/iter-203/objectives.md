# Iter-203 objectives — per-lane detail

## Lane COE — `AlgebraicJacobian/Albanese/CodimOneExtension.lean`

Mode: `mathlib-build`. Helper budget 3. Priority-1 (sole open
critical-path root). Blueprint: `Albanese_CodimOneExtension.tex`,
`\subsec:stage6_iib_substrate_iter200`.

**References (USER reference-driven directive)**:
- Matsumura, *Commutative Ring Theory*, Thm 14.2 (regular sequence
  ⟺ part of a system of parameters / κ-linear independence of cotangent
  images in a regular local ring).
- Stacks 00NQ (regular local ⇒ domain; A/(f) regular under f∉𝔪²),
  00SW/00OW (Koszul-regular relations of a submersive presentation),
  00OE (smooth-algebra Krull-dimension formula).

**Step A1 (PRIMARY / HARD BAR)** — `private theorem
matsumura_isRegular_of_linearIndependent_cotangent`:
- Statement: regular local Noetherian `(A,𝔪)`, `ringKrullDim A = n`,
  `rs : Fin n → A` with `rs i ∈ 𝔪` and `LinearIndependent κ
  (Ideal.toCotangent ∘ rs)` ⟹ `rs` is an `IsRegular` sequence.
- Proof: induction on `c` (= the count). dim-drop by
  `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`
  (Mathlib/RingTheory/KrullDimension/Regular.lean); `f₁` a
  non-zero-divisor via `RingTheory.CohenMacaulay.isDomain_of_regularLocal`
  (now public, AuslanderBuchsbaum.lean L2657) + `f₁ ∉ 𝔪²`;
  `A/(f₁)` regular-local via
  `RingTheory.CohenMacaulay.regularLocal_quotient_isRegularLocal_of_notMemSq`
  (now public, L2293); descend by `isRegular_cons_iff`.
- Insert between iter-201 `ringKrullDim_quotient_localization_MvPolynomial_of_regular`
  (~L924) and `exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`.
- No new import line (AuslanderBuchsbaum already imported); use the
  fully-qualified `RingTheory.CohenMacaulay.*` names.

**PUSH-BEYOND (sorry-closing stretch)**:
- Stage 6.A capstone `ringKrullDim_localization_eq_relativeDimension`
  (Stacks 00OE) via the 3-step chain (height = KrullDim →
  height-of-maximal-ideal → additive regular-sequence form) on the
  iter-200/201 substrate.
- B.d regular-stalk close: consume B.a (`exists_submersivePresentation…`),
  B.b (`isLocalization_atPrime_stalk_of_affineOpen`), B.c, Step A1, the
  capstone → close the **L1262 `isRegularLocalRing_stalk_of_smooth`** sorry.
- Residue-field route (`finrank_cotangentSpace_of_bijective_algebraMap_residue`)
  is INAPPLICABLE for general codim-1 z — do not attempt it.

**SCOPE FENCE**: do not touch L1459 / L1534.
**Cascade**: L1262 closure fires the Lane T32 re-engagement trigger.
**Escalation pre-commitment**: 0 sorries closed ⇒ mandatory USER
escalation before any iter-204 COE dispatch (PROGRESS.md).

## Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

Mode: `mathlib-build`. Helper budget 4. Priority-2.5 (gates A.1.c body).
Blueprint: `Picard_TensorObjSubstrate.tex` (complete).

**References**:
- `Mathlib.CategoryTheory.Monoidal.PresheafOfModules`
  (`PresheafOfModules.Monoidal.tensorObj` — presheaf-level monoidal op).
- Zariski-site sheafification on `Scheme.Modules X`.

**Piece 1 (PRIMARY / HARD BAR)** — fill `tensorObj` body:
- Lift `PresheafOfModules.Monoidal.tensorObj` of the underlying
  presheaves of `M`, `N` through the small-Zariski-site sheafification
  functor of `X`. Build `tensorObj_isLocallyTrivial` axiom-clean as a
  supporting helper.
- HARD BAR: `tensorObj` body axiom-clean (closes 1 of 6 stubs), OR —
  if the sheafification seam is genuinely blocked — a precise hand-off
  of the seam + axiom-clean substrate built toward it (no NEW sorry per
  mathlib-build invariant; leave existing stubs untouched).

**Then (budget permitting)**: `tensorObj_functoriality` (f ⊗ g),
then `monoidalCategory` (MonoidalCategoryStruct + pentagon/triangle/hexagon).

**CONTAMINATION GUARD**: `monoidalCategory` is a `sorry` instance — do
NOT add any axiom-clean declaration that synthesizes
`MonoidalCategory X.Modules` until that instance body is filled.

**Watch**: Zariski-site sheafification compatibility is the first
nontrivial seam (progress-critic route203). If blocked, hand off
precisely rather than forcing.
