# Progress-critic directive — iter-031

Assess convergence of the two active routes the planner is considering for prover
assignment this iter. Verdict per route. K = 4 iters of signals below.

## Route A — 02KG affine-vanishing infrastructure
Files (in dependency order): `FreePresheafComplex.lean` → `CechBridge.lean` (family form) → `AffineSerreVanishing.lean`.
This iter's proposed prover file: **`CechBridge.lean`** — build the family-parameterized
`injective_cech_acyclic` (`{ι}[Finite ι](U : ι → Opens X)`), consuming the just-landed
`cechFreeComplex_quasiIsoFam`. Mirrors the existing axiom-clean `X.OpenCover` `injective_cech_acyclic`.

Signals (sorry counts are file-local; all these files stay 0-sorry — work is axiom-clean helper growth):
- iter-028: (route not active — 01EO chain in a different file).
- iter-029: `AffineSerreVanishing.lean` +3 axiom-clean helpers. Status PARTIAL — stopped on a genuine
  design fork (⊤-vs-`D(f)` cover mismatch). 0→0 sorry.
- iter-030: `FreePresheafComplex.lean` +50 axiom-clean `…Fam` decls, culminating in
  `cechFreeComplex_quasiIsoFam` (cover-agnostic free resolution quasi-iso). Status COMPLETE
  (whole objective landed, design fork's hard half dissolved). 0→0 sorry.
- iter-031 (planned): `CechBridge.lean` family `injective_cech_acyclic` — mirror of a done proof.
- Strategy: phase "02KG affine_serre_vanishing", Iters-left estimate ~4, phase entered ~iter-029.

## Route B — 01I8 qcoh F ≅ ~(ΓF) globalisation
File: `QcohTildeSections.lean`.
This iter's proposed prover file: **`QcohTildeSections.lean`** — build the FIRST decomposed atomic
sub-lemma of 01I8 step 1: the localisation-of-sections fact `Γ(D(f),F) ≅ Γ(Spec R,F)_f` for qcoh `F`
(Hartshorne II.5.14-style), as the foundation of affine global generation. (Planner is decomposing the
step into reference-anchored sub-lemmas this iter — this is NOT a relabel of the gap; it is the first
provable Mathlib-gradient ingredient.)

Signals:
- iter-029: `QcohTildeSections.lean` +4 axiom-clean (conditional `[IsIso fromTildeΓ]→F≅~ΓF` + presentation
  form + 2 accessors). Status PARTIAL. Blocker phrase: "needs the instance `[IsQuasicoherent F]→IsIso
  F.fromTildeΓ`". 0→0 sorry.
- iter-030: `QcohTildeSections.lean` +3 axiom-clean (steps 2-3: `isIso_fromTildeΓ_of_genSections`,
  `qcoh_iso_tilde_sections_of_genSections`, `free_isQuasicoherent`). Status PARTIAL. Blocker phrase:
  "01I8 step 1 affine global generation; `Γ(D(f),F)=Γ(X,F)_f` and qcoh abelian-subcategory closure both
  ABSENT from Mathlib; ~few-hundred LOC". The prover DELIBERATELY declined a single-hypothesis relabel
  (recognised it as a relabel, not progress). 0→0 sorry.
- iter-031 (planned): decompose 01I8 step 1 into reference-anchored atomic sub-lemmas + dispatch the
  first one (localisation-of-sections) as `mathlib-build`.
- Strategy: same "02KG" phase (01I8 is a sub-need of `affine_cech_vanishing_qcoh`); ~4 Iters-left;
  01I8 explicitly named as ~few-hundred-LOC gap, no Mathlib shortcut.

## This iter's PROGRESS.md `## Current Objectives` proposal (2 files)
1. `CechBridge.lean` — family `injective_cech_acyclic` [mathlib-build] (Route A).
2. `QcohTildeSections.lean` — 01I8 step-1 localisation-of-sections sub-lemma [mathlib-build] (Route B).
(`AffineSerreVanishing.lean` deferred to next iter — it transitively imports `CechBridge`, so co-dispatch
would race with lane 1.)

Specifically assess: is Route B (2 consecutive PARTIAL iters on the same file, blocked on an absent-from-
Mathlib fact) CHURNING/STUCK, or is the planned decompose-into-reference-anchored-sub-lemmas the correct
corrective that breaks the pattern? And is Route A CONVERGING?
