# Wave-5 worksheet — the Pic⁰ abelian-variety package (BINDING)

*Design pass, 2026-07-17 night session (W5/W6 orchestrator). Derived from
`informal/w5-recon.md` (read in full; its §2 API map is the evidence base) after the
recon's routes were weighed. Decisions here are BINDING for Wave-5 lanes; deviations go
through the orchestrator. Models: `w4-datum-worksheet.md`, `dat-d-worksheet.md`.
Division of labor tonight: the parallel fleet owns AJCR.w4-rep.datum.* / re5 and the
DD/DAT file lanes — Wave-5 files must stay outside them (file map D7).*

**VERDICT IN ONE LINE.** Wave 5 = three instances on `d.J` stated against the pinned
`JacobianData` interface (landed tonight, structure-only); properness + irreducibility
run on ONE shared interface (`AbelSourceData`, route P-B/GI-(a): image of a proper Abel
source), whose discharge is the single cross-wave gate; smoothness runs the recon's
tangent chain T1→T5 with T4 (étale-plus collapse at `k[ε]`) and S1/S3 mandated
WORKSHEET-FIRST — everything else launches as S/M bricks tonight.

---

## §0 Lane protocol (every Wave-5 agent, non-negotiable)

1. Read `informal/protocol-concurrent-lanes.md` (private-index+CAS commits, mkdir lake
   mutex, /tmp hygiene) and the kernel-discipline sections of
   `informal/session-handoff-2026-07-14.md`, `-14b.md`, `-15.md`.
2. Zero sorries; files ≤ 500 lines; `autoImplicit false`; explicit binders (never
   local-notation-typed section binders); doc-comments after `set_option ... in`;
   opaque-insertion for repeated composites; kernel timeout ⇒ restructure.
3. `lean_verify` every keystone: axiom-clean = [propext, Classical.choice, Quot.sound].
4. Never edit `Challenge.lean` or any `archon-protected.yaml` name. Never register a
   staged/hypothetical fact as an `instance`.
5. LSP-first iteration; `lake` only under the mutex, narrowest faithful check
   (`lake env lean <file>` before full builds); commit every green stage IMMEDIATELY
   (private index + CAS + post-commit `show --stat HEAD` scope check).
6. Roadmap item updated at every milestone (math-first notes). Foreign red root build
   outside your dependency cone: verify YOUR module closure green, commit with caveat.
7. Another fleet commits concurrently tonight: never `add -A`; only your own paths.

## §1 Decisions

- **D1 (interface file).** `Picard/JacobianData.lean` lands TONIGHT, containing exactly
  the frozen §1.1 shape of `w4-datum-worksheet.md` (structure `JacobianData C` with
  fields `J`, `rep`, `locallyOfFiniteType`, `quasiCompact`) plus the design-§5
  consumers only: `d.grpObj := GrpObj.ofRepresentableBy …` (the `forget₂ ⋙ forget`
  defeq massage owned there, once), `homEquiv` access, `uniqueUpToIso`. NO producer:
  `jacobianData` stays DAT-J (parallel fleet); an inbox note records the split. Any
  later DAT-J needs on this file are additive.
- **D2 (phrasing).** Honest group-scheme generalities (X1, X2) are stated over
  `(G : Over (Spec (.of k))) [GrpObj G]` + explicit hypotheses (mathlib-conventions:
  reusable infrastructure), with `(d : JacobianData C)` corollaries in the same file.
  Everything Pic⁰-specific is stated against `(d : JacobianData C)` per design §5.
  The three frozen instances are Wave-5 THEOREMS about `d.J`; instance packaging at the
  frozen gate happens at DAT-J discharge time.
- **D3 (properness + irreducibility, one substrate).** Route **P-B** primary with
  **GI-(a)**, both through one new interface (file `AbelianVariety/AbelSource.lean`):
  `AbelSourceData d` = a source `D : Over (Spec (.of k))` with `[IsProper D.hom]` and
  geometric irreducibility/reducedness certificates, a morphism `abel : D ⟶ d.J`, and
  field-point surjectivity after base change to every field `K/k` (exact spelling
  fixed by the P2 spec against the landed `BaseChangeInstances` stack; use
  residue-field points; the P2 prover owns it). W5 proves tonight-or-next:
  `UniversallyClosed d.J.hom` (P2: `UniversallyClosed.of_comp_surjective`, composite =
  `D.hom`), `IsProper d.J.hom` (P3 = X1 + P2 + `d.locallyOfFiniteType`),
  `GeometricallyIrreducible d.J.hom` (G1: irreducible-image topology brick +
  `isIntegral_tensorObj_left` + base-change instances). The interface DISCHARGE
  (P1: proper `Div^d`-derived source + Abel morphism via `d.rep.homEquiv.symm` +
  `fiberTwist`-shift + `riemann_inequality_curve`) is the ONE cross-wave gate — it
  waits for the DD lanes' shapes (DD-Q quasi-projectivity, DD-R) to freeze; do NOT
  spec it against tonight's moving DD tree. **P-A is REJECTED** (two mathlib-absent
  algebra mountains: regular-local⇒UFD, DVR-refined valuative criterion). P-C recorded
  as fallback if the proper-scheme delta on `Div^d` balloons.
- **D4 (smoothness chain).** Recon chain adopted: T1 (dual-number kit port), T2
  (trunc-exp Čech kernel port), launchable now; T3 (relPic ε-kernel) after T2;
  **T4 WORKSHEET-FIRST** (balloon risk R1) — tonight a read-only probe settles: does
  the pinned mathlib have henselian étale-cover splitting for Artin local rings
  (`k̄[ε]`)? route (i) k̄-side splitting + k→k̄ comparison vs route (ii) kernel-level
  Hilbert-90 over k; **S1 WORKSHEET-FIRST** (route α1 only: two-term-H²=0 square-zero
  lifting; NEVER Exchange/semicontinuity — descope boundary R6); S2 =
  `smooth_of_grpObj` [XS]; **S3 WORKSHEET-FIRST** (rel-dim numeral; probe
  `HasRingHomProperty.descendsAlong_flat` at
  `Locally (IsStandardSmoothOfRelativeDimension n)` early — it decides whether the
  chain lives at k̄).
- **D5 (X3 feeds everything k̄-side).** `H¹(C,𝒪) ⊗_k K ≃ₗ[K] H¹(C_K,𝒪)` + genus
  invariance, engine-grade (landed `relTwistPairDiffBaseChange` pattern +
  `Over.sectionsBaseChange`), NOT II.5. Launch now.
- **D6 (hygiene inherited).** Old-draft ports are SHAPE ports: re-kernel-verify
  everything (falsely-marked-proved incident); scalar-identity-first for any dimension
  transport (W12 lesson: ONE `finrank` identity, then one non-canonical `≃+`); the
  Mumford-scaling `(a+b)•x` distributivity gap must be dodged cocycle-side or closed
  explicitly — no prover discovers it mid-brick (it is named HERE).
- **D7 (file map — all outside the parallel fleet's lanes).**
  `Picard/JacobianData.lean` (D1); `AbelianVariety/GroupSeparated.lean` (X1),
  `AbelianVariety/Translation.lean` (X2), `AbelianVariety/AbelSource.lean` (P2/P3/G1);
  `Cohomology/H1BaseFieldInvariance.lean` (X3; splits if >500L);
  new dir `Tangent/` for the T-chain (T1: `Tangent/DualNumberUnits.lean`,
  `Tangent/TangentSpaceDualNumbers.lean`, `Tangent/TangentSpaceSchemePoints.lean`,
  `Tangent/TangentSpaceStalkAlgebra.lean`, `Tangent/TangentSpaceIdentitySection.lean`,
  `Tangent/Pic0TangentSpace.lean`; T2: `Tangent/TruncExpCech.lean` + follow-ons;
  T3: `Tangent/RelPicEpsilonKernel.lean`). Never touch: `Cohomology/GluedSheaf*`,
  `Cohomology/DatumDescent*`, `Picard/DivisorFamily*`, `Picard/Grassmannian*`,
  `Picard/SectionsToDivisors*`, `RiemannRoch/WindowLedger|SectionBound`, the W6-full
  DAT-3 lane, DD-F P-fib files.

## §2 Brick ledger (statuses live in the roadmap, `AJCR.w5-av.*`)

| Brick | Content | Size | Gate |
|---|---|---|---|
| data | D1 interface file | S | none — tonight |
| x1 | `IsSeparated` of a lft group scheme over a field (lem:agps(1): diagonal = `α⁻¹(e)`, `IsClosedImmersion η[G].left`) + datum corollary | S | data |
| x2 | translation isos + transport of point-local properties (mine `Group/Smooth.lean` private lemmas first) | S | data |
| x3 | H¹ base-field invariance + genus invariance | M | none — tonight |
| t1 | dual-number kit port (5 files, mathlib-only) | M | none — tonight/next |
| t2 | trunc-exp Čech kernel on TwoCover section rings (old §6+§7 port) | M | none — tonight |
| t3 | `ker(relPic(k[ε]) → relPic(k)) ≃+ H¹(C,𝒪)` (nilpotent unit-lifting + `sectionsBaseChange` at `k[ε]`) | M | t2 |
| t4 | étale-plus collapse at `k[ε]` | M/L | WORKSHEET (probe tonight) |
| t5 | `finrank T₀(d.J) = genus C` scalar identity | S/M | t1–t4 |
| s1 | geometrically reduced at identity (α1) | M/L | WORKSHEET; t-chain |
| s2 | `Smooth d.J.hom` via `smooth_of_grpObj` | XS | s1 |
| s3 | `SmoothOfRelativeDimension (genus C)` assembly | M/L | WORKSHEET; s2+t5+x2 |
| p1 | AbelSourceData discharge (proper `Div^d` + abel) | L | CROSS-WAVE: DD shapes freeze |
| p2 | `UniversallyClosed d.J.hom` from AbelSourceData | M | data (interface-conditional) |
| p3 | `IsProper d.J.hom` assembly | XS | x1+p2 |
| g1 | `GeometricallyIrreducible d.J.hom` from AbelSourceData (GI-(a)) | M | data (interface-conditional) |

Launch order tonight: {data+x1+x2}, {x3}, {t2} in wave A; {t1}, {t4-probe} wave A/B;
{t3}, {p2+p3+g1 conditional package} wave B/C as slots free; worksheets for t4/s1/s3
before any code on them; p1 only after DD freeze (orchestrator gate).
