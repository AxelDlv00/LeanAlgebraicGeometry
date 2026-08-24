# SPEC DD1-PT-SEAM — adjudication of the pt-transport seam (`AJCR.w4-rep.datum.dat-d.dd1`)

*2026-07-17, Fable design-adjudication lane. BINDING parents: I-0194 (the mapAlg lane's
finding — the pigeonhole obstruction is REAL and its escapes (a)/(b)/(c) are the option
set), `informal/spec-dd-1.md` §1a (the frozen carrier), `informal/spec-dd-r.md` §2/§3.8
(the DDR-9 gate), I-0179/I-0182/I-0186 (the field-dictionary lane), I-0192 (DD-4 Task 7
note). Every consumer row below was verified by direct source read this pass
(file:line); a scratch ELABORATION PROBE of the §5 spellings was run GREEN against the
pinned tree (`lean_run_code`, zero diagnostics: the weakened field, the strong-witness
constructor, the regularity rework). No .lean file edited; no build run.*

## 0. The seam being adjudicated

`DivisorAdaptation` (Picard/DivisorFamily.lean:230) carries a four-field refinement
witness: `pt : index → relCurve C R` (:235), `piece_le : ∀ j, pieces j ≤ d.cover.opens
(pt j)` (:237), `unit : ∀ j, Γ(pieces j)ˣ` (:239), `eqn_eq : ∀ j, eqn j = unit j *
res (d.eqn (pt j))` (:241). Base-changing it along `relCurveMap C R R'` requires a point
of `relCurve C R'` above each `A.pt j`; the mapAlg lane PROVED this unobtainable for
arbitrary test maps (I-0194: on `C.left = Spec k⁴` — legal, only `[IsAffineHom π]` is
pinned — 6 pairwise-incomparable 2-point pieces defeat every reindexing/member-
enlargement/DivEq-representative trick against 4 available points). Landed escape (a):
`DivFam.mapAlgOfSurjective` (DivisorFamilyMapAlg.lean:256) for surjective comparisons.
The question: **(b) weaken the carrier's witness to a pointwise-local field, vs (c) a
W-refinement-invariance brick, vs reshaping the consumers.**

## 1. VERDICT

**Option (b): replace the four witness fields by ONE pointwise-local Prop field
(`eqn_germ_eq`, §5), executed as a TWO-COMMIT migration inside a freeze window that
opens only after the two live carrier-consuming lanes land (§7).** Evidence: the
unconditional `mapAlg` is unavoidable (§2 — the vehicle's OBJECT and DDR-9's
`RepresentableBy` both quantify over non-surjective comparisons); the witness fields
are consumed directly at exactly 8 sites in 6 files, all pointwise-local in nature, and
every downstream consumer reads witness-free derived lemmas whose STATEMENTS are
unchanged (§3); the weakened field base-changes along arbitrary test maps by landed
mechanisms with no choice and no surjectivity (§5c). **(c) is REJECTED as the primary
route** and recorded as the staged fallback (§8): its honest content (certificate
transport across piece refinement) is DDR-4/`hdeg`-grade (L–XL), duplicates machinery
two other bricks own, and would permanently conjugate every base change by refinement
isos, destroying the landed exact-defeq discipline (I-0194 hazards). **Consumer
reshaping is REJECTED as unviable**: the non-surjective demand comes from mathlib's
`RepresentableBy` itself and from the stage-(e) vehicle's own compat field — no
consumer-side restatement removes it without abandoning representability. **(a) stays
landed** and correctly serves exactly the DD-2 cover row.

## 2. The demand trace — who needs which `mapAlg` (the decisive evidence)

| consumer | comparison maps quantified over | served by (a) surjective-only? |
|---|---|---|
| DD-2 sheaf statement (covers) | faithfully flat test maps; `Spec R' → Spec R` surjective ⟹ base change surjective (one Spec-surjectivity lemma, I-0194) | **YES** |
| stage-(e) vehicle OBJECT (spec-dd-1 §1e; pattern `Picard/PicEt.lean:91–98`) | `Over.resAlgHom T h : Γ(V) →ₐ Γ(U)` for arbitrary affine opens `U ≤ V` — `relCurveMap` is an **open immersion**, not surjective for `U ⊊ V` | **NO** — the vehicle's subtype does not even exist |
| **DDR-9 `divRep` (spec-dd-r §3.8) — THE DECISIVE ROW** | mathlib `Functor.RepresentableBy.homEquiv_comp : ∀ {X X'} (f : X ⟶ X') (g : X' ⟶ Y), homEquiv (f ≫ g) = F.map f.op (homEquiv g)` (verified by `#print` this pass) — **ALL morphisms of the test category**, i.e. arbitrary k-algebra maps at affines; and per spec-dd-r §2 the mapAlg+vehicle+DD-2 stack is needed "for `divFunctor` to *be* a functor — for the `RepresentableBy` statement to even typecheck" | **NO** |
| DD-4 Task 7 / ε naturality (I-0192 "FOR TASK 7") | arbitrary `R → R'` | **NO** |
| DAT-C 01JJ pullback rows (spec-dd-1 §4, spec-dd-r §6) | arbitrary (open-immersion fibre products included) | **NO** |

Conclusion: the seam MUST be closed unconditionally; (a) alone strands the vehicle,
DDR-9, DD-4 Task 7, and DAT-C. Only (b) or (c) can close it.

## 3. The consumption table — every direct use of `pt`/`piece_le`/`unit`/`eqn_eq`

Full-tree grep this pass (`\.pt\b`, `piece_le`, `eqn_eq`, `\.unit`, `DivisorAdaptation`
across all .lean). The witness surface is exactly 8 sites in 6 files; the unrelated
`BasicRefinement.pt`/datum `.unit` hits (PicAffine, WitnessComponents, CechPicSurjective,
DivisorThetaDatum:420–432) are different structures.

| # | site | fields used | what it establishes | pointwise-local sufficient? |
|---|---|---|---|---|
| 1 | DivisorFamily.lean:235–242 | the carrier | the definition | — (the seat of the change) |
| 2 | DivisorFamily.lean:252–260 `eqn_regular` | all four | germ regularity of `eqn j` at `z ∈ pieces j` | **YES** — probe-verified 4-line rework (§5b) |
| 3 | DivisorFamilyPullbackMap.lean:146–150 `eqn_mem_nonZeroDivisors` | eqn_eq, unit, pt, piece_le | SECTION-level regularity on the piece | **YES** + one S helper: germwise-regular ⟹ section-regular via `TopCat.Presheaf.section_ext X.sheaf` (already used in-tree: DivisorStalkIdeal.lean:65,:128; DivisorClass.lean:141) |
| 4 | DivisorFamilyPullbackMap.lean:177–310 `germ_pullbackEqn_mem_nonZeroDivisors` (the DD-1a hreg discharge) | all four + `d.ratioUnit (A.pt j) (f y)` | germs of `pullbackEqn` regular everywhere | **YES** — the proof already works at a single `z`; the section-level `hdecomp` (:228–248) becomes a stalk-level decomposition through the same `ratioUnit` (DivisorClass.lean:155) at `(x, f y)`; `hgermF`/`hgermG`/stalk-unit transport (:198–310) unchanged in shape |
| 5 | DivisorFamilyFieldDegree.lean:161–182 `coeffAt_eq_toAdd_ordZ_eqn` | eqn_eq at η, pt, piece_le at z | `ordZ f_j = coeffAt D` at closed `z ∈ piece` | **YES** — stalk-unit at `z` has trivial order via the landed `Scheme.isUnit_germ_iff_ordZ_eq_one` (I-0179 public core); `d.presentation.ordZ_elem_eq K hzg hx` takes exactly the pointwise membership `hx : z ∈ d.cover.opens x`; stalk-to-functionField plumbing already in the file (germGenericUnits calculus) |
| 6 | DivisorFamilyTheta.lean:322–329 `germ_eqn_span_eq_stalkIdeal` | eqn_eq, unit, pt, piece_le | `span {germ f_j} = d.stalkIdeal z` | **YES**, and SIMPLER — `d.germ_eqn_span_eq` (DivisorStalkIdeal) already accepts ANY covering member at `z`; the pointwise field is its exact input |
| 7 | DivisorFamilyExtraction.lean:74–86 `exists_divisorAdaptation` | CONSTRUCTS all four | the extraction (constructor side) | strong data (anchors + subordination + unit 1) available for free — routed through `mkOfWitness` (§5a), 3-line change |
| 8 | DivisorFamilyMapAlg.lean (whole kit: BaseChangeWitness:133, ofSurjective:140, witness_piece_le:149, ofWitness:166, baseChangeOfSurjective:244, mapAlgOfSurjective:256) | all four | the surjective-only base change | REPLACED by the unconditional transport (§5c). `mapAlgOfSurjective`/`BaseChangeWitness` have **ZERO consumers** in-tree (grep this pass; nothing imports DivisorFamilyMapAlg except the root) — freely rewritable |

**Everything else is witness-free.** DivisorFamilyPullback/PullbackCert/PullbackGlued/
PullbackOverlap, DivisorFamilyField/FieldEquiv/Backward/Window, DivisorThetaDatum/
Bridge/TrivializeZero/TrivializeOne(in-flight)/ThetaGlue(in-flight)/ThetaSurj, and the
DDR-1 DivCarve*/DivScheme files consume only `eqn`/`pieces`/colength/glued apparatus or
the derived lemmas of rows 2–6, whose statements never mention the witness. Grep of the
two in-flight DD-4 files on disk: zero witness hits. So the migration's blast radius is
6 files, and downstream re-verification is a rebuild, not an edit.

**Constructor-side check (rows 7 + DDR-3).** DDR-3 (spec-dd-r §3.3) builds its
adaptation by the `exists_divisorAdaptation` Extraction:54 pattern — Nakayama
neighbourhoods subordinated to the cover at fibrewise achiever anchors — i.e. it
produces the STRONG witness for free and calls `mkOfWitness`. The weakening never hurts
a constructor (strong ⟹ weak, probe-verified); it only removes the obligation the
TRANSPORT could not meet. If anything DDR-3's life gets marginally easier (it may cite
`eqn_germ_eq` directly where its neighbourhoods are naturally pointwise).

## 4. Why (b) beats (c)

**(c) sized honestly (L–XL, not M–L).** The (c) route keeps the carrier and, at each
base change, refines the pulled `FinCoverData` into pulled-cover members (possible:
every `z'` lies in its OWN pulled member `f⁻¹(opens (f z'))`; qc basic-open
subdivision), then must transport the certificate across the refinement. Two honest
walls: (i) a refined piece's colength is a localization of `Γ(D(h))⧸(f)` at a
SECTION-ring element — finiteness/projectivity over `R'` is NOT formal (it is the
piece-isolation/support-tube content DDR-4 buys with `IsProper C.hom`); (ii) glued-
module refinement invariance is the adaptation-independence flavour I-0179 priced as
the XL wall for the RANK alone (here needed as modules, with all four certificate
clauses). The mapAlg lane already probed and killed every cheaper (c)-shaped variant
(I-0194). And structurally: (c) makes every future base change carry refinement
conjugation isos, breaking the landed "state against pulled*, instantiate by
exact-defeq" discipline that PullbackCert/Glued and `isCertified_ofWitness` rely on.

**(b) sized honestly (one focused session).** 6 files; rows 2–6 are proof-internal
reworks against unchanged statements; the §5 spellings elaborate (probe); the
transport's three mechanisms are landed in-tree (PullbackMap:250–271 `hgermG`,
:228–248 germ decomposition, DivisorClass:155 `ratioUnit`). Zero downstream edits.

**Hybrid "second constructor + upgrade lemma" is mathematically closed off**: upgrading
a weak witness to the strong carrier IS the pigeonhole-obstructed step — the recorded
counterexample kills it, not just the probe budget. The only sound hybrid is the
staging of (b) itself (§7's two commits), which this spec adopts.

## 5. The pinned Lean-ready shape (probe-verified this pass, zero diagnostics)

**(5a) The carrier flip + the strong-witness constructor** (Picard/DivisorFamily.lean).
Fields `pt`/`piece_le`/`unit`/`eqn_eq` DELETED; ONE Prop field added. Binder shape is
BINDING (commit 1 must coin the derived lemma with this exact signature so the flip is
consumer-invisible):

```lean
structure DivisorAdaptation [IsAffineHom π] (d : (relCurve C R).LocalEquations) :
    Type u extends FinCoverData C R π where
  eqn : ∀ j : toFinCoverData.index, Γ(relCurve C R, toFinCoverData.pieces j)
  /-- The pointwise refinement witness: at every point of a piece, some member of
  `d.cover` contains it and the equation's germ agrees with `d`'s up to a stalk unit. -/
  eqn_germ_eq : ∀ (j : toFinCoverData.index) (z : relCurve C R)
      (hz : z ∈ toFinCoverData.pieces j),
    ∃ (x : relCurve C R) (hx : z ∈ d.cover.opens x)
      (u : ((relCurve C R).presheaf.stalk z)ˣ),
      ((relCurve C R).presheaf.germ (toFinCoverData.pieces j) z hz).hom (eqn j)
        = (u : (relCurve C R).presheaf.stalk z)
          * ((relCurve C R).presheaf.germ (d.cover.opens x) z hx).hom (d.eqn x)

/-- Strong-witness constructor: the frozen carrier's four fields (the extraction /
DDR-3 / backward-map shape) produce the pointwise field. Probe: proof is
`Units.map (germ …)` + `germ_res_apply`. -/
noncomputable def DivisorAdaptation.mkOfWitness (D : FinCoverData C R π)
    (eqn : ∀ j : D.index, Γ(relCurve C R, D.pieces j))
    (pt : D.index → relCurve C R)
    (piece_le : ∀ j, D.pieces j ≤ d.cover.opens (pt j))
    (unit : ∀ j, Γ(relCurve C R, D.pieces j)ˣ)
    (eqn_eq : ∀ j, eqn j = (unit j : Γ(relCurve C R, D.pieces j))
      * ((relCurve C R).presheaf.map (homOfLE (piece_le j)).op).hom (d.eqn (pt j))) :
    DivisorAdaptation C R π d
```

**(5b) The reworked derived lemmas** (statements UNCHANGED — rows 2–6): `eqn_regular`
(probe: 4 lines — `obtain ⟨x, hx, u, hu⟩ := A.eqn_germ_eq j z hz; rw [hu]; exact
mul_mem u.isUnit.mem_nonZeroDivisors (d.regular x z hx)`); new S helper
`Scheme.mem_nonZeroDivisors_of_forall_germ : (∀ z hz, germ z s ∈ (stalk z)⁰) → s ∈
Γ(X,U)⁰` (annihilator has all germs zero, `TopCat.Presheaf.section_ext X.sheaf`), home
Picard/DivisorClass.lean or PullbackMap; then rows 3–6 rework as in the §3 table.

**(5c) The unconditional transport** (Picard/DivisorFamilyMapAlg.lean, rewritten):

```lean
noncomputable def DivisorAdaptation.baseChange
    (hproj : ∀ j, Module.Projective R (A.colength j)) :
    DivisorAdaptation C R' π (A.pulledEquations R' hproj)
  -- toFinCoverData := A.toFinCoverData.baseChange R'; eqn := A.pulledEqn R'  (both as
  -- in ofWitness — the pulled apparatus stays DEFEQ, so isCertified transport is
  -- verbatim isCertified_ofWitness with the witness argument deleted)

theorem DivisorAdaptation.isCertified_baseChange {n} (hc : A.IsCertified n) :
    (A.baseChange R' hc.projective_colength).IsCertified n

noncomputable def CertifiedDivisorFamily.baseChange … -- ofSurjective minus hsurj
noncomputable def DivFam.mapAlg : DivFam C R π n → DivFam C R' π n
lemma DivFam.picClass_mapAlg …   -- the Abel hook, as picClass_mapAlgOfSurjective
```

The `eqn_germ_eq` transport, mechanism (no choice, no surjectivity): for
`z' ∈ (baseChange).pieces j`, `f z' ∈ pieces j` (`pieces_baseChange`); apply
`A.eqn_germ_eq` at `f z'` → `(x, hx, u)`; **take the pulled member at `x' := z'`
itself** (`z' ∈ f⁻¹(opens (f z'))` by the pointed-cover law); then
`germ_{z'}(pulledEqn j) = stalkMap(germ_{f z'}(eqn j))` (landed `hgermF`-shape,
PullbackMap:205–225) `= stalkMap(u) ⬝ stalkMap(germ(ratioUnit x (f z'))) ⬝
germ_{z'}(pullbackEqn f d z')` (landed `eqn_restrict_eq`/`ratioUnit` at
`f z' ∈ opens x ⊓ opens (f z')`, membership from `hx` + the cover law; landed
`hgermG`-shape :250–271) — stalk units map to stalk units. DELETED with zero consumers:
`BaseChangeWitness`, `ofSurjective`, `witness_piece_le`, `ofWitness`,
`baseChangeOfSurjective`, `mapAlgOfSurjective` (DD-2 consumes `mapAlg` directly;
if a surjective-named entry is wanted, keep `mapAlgOfSurjective := fun _ => mapAlg`
as a one-line abbrev — implementer's choice).

**Out of scope for the migration** (stays the recorded DD-1 remainder): `mapAlg`
id/comp laws (need `relCurveMap` functoriality), the stage-(e) vehicle file, DD-1b
named corollary. The flip UNBLOCKS them; it does not deliver them.

## 6. The consumer-migration map (per file)

| file | change | effort |
|---|---|---|
| Picard/DivisorFamily.lean | field swap (−4 +1), `mkOfWitness`, `eqn_regular` rework | S (probe-written) |
| Picard/DivisorClass.lean or PullbackMap | new `mem_nonZeroDivisors_of_forall_germ` helper | S |
| Picard/DivisorFamilyExtraction.lean | route the final `exact ⟨{…}⟩` through `mkOfWitness` | S (3 lines) |
| Picard/DivisorFamilyTheta.lean | `germ_eqn_span_eq_stalkIdeal` rework (row 6) | S (~8 lines) |
| Picard/DivisorFamilyFieldDegree.lean | `coeffAt_eq_toAdd_ordZ_eqn` rework (row 5) | S→M (~25 lines) |
| Picard/DivisorFamilyPullbackMap.lean | rows 3–4 reworks | M (~150 lines touched, skeleton preserved) |
| Picard/DivisorFamilyMapAlg.lean | §5c rewrite | M (net simpler than today's kit) |
| everything else (Theta*, Field*, Backward, Window, Pullback*, DivCarve*, DivScheme*) | NONE — rebuild only | 0 |

Re-verification plan: per-file `lake env lean` on the 7 touched files; ONE full root
`lake build` under the mkdir-mutex (I-0190: per-file checks cannot catch cross-file
breakage); `lean_verify` keystones (`DivFam.mapAlg`, `picClass_mapAlg`,
`isCertified_baseChange`, `exists_divisorAdaptation`) axiom-clean
`[propext, Classical.choice, Quot.sound]`; `hgraph sync` after (nodes reference
`coeffAt_eq_toAdd_ordZ_eqn` etc. by name — names survive; deleted decls get a node
comment).

## 7. Execution window and order (BINDING — two lanes are live on the carrier)

**The window opens when BOTH hold:**
- (w1) the DD-4 Task-4 lane lands its in-flight files — `Picard/DivisorThetaGlue.lean`
  and `Picard/DivisorThetaTrivializeOne.lean` are untracked on disk this pass (git
  status of the ledger); neither touches the witness fields, but a carrier edit under
  their feet forces mid-proof rebuilds and risks a shared-file race;
- (w2) the DDR-3 lane's `Picard/DivSchemeFamily.lean` is either LANDED or NOT STARTED
  (absent from disk this pass). If DDR-3 is mid-flight at w1, coordinate: DDR-3 should
  build its adaptation through the `mkOfWitness` argument list (it is the Extraction:54
  pattern anyway), which makes its file flip-proof up to the one constructor name.

**Inside the window (single lane, freeze on `Picard/DivisorFamily*.lean`):**
- **Commit 1 (non-breaking, green against the FROZEN carrier):** add
  `DivisorAdaptation.eqn_germ_eq` as a DERIVED LEMMA with the §5a signature EXACTLY
  (trivially provable from today's `eqn_eq`), add the S helper, and rework rows 3–6 to
  consume ONLY `eqn_germ_eq`. After this commit the four witness fields have exactly
  two remaining consumers: the lemma's own proof and MapAlg.
- **Commit 2 (the flip, atomic):** swap the fields (§5a — the lemma becomes the field,
  same name and signature, consumers of commit 1 untouched), add `mkOfWitness`, switch
  Extraction, rewrite MapAlg per §5c. Root build + keystones before the CAS push.
- Both commits via the private-index+CAS recipe (`informal/protocol-concurrent-lanes.md`
  §1) with `show --stat HEAD` verification; root import file untouched (no new module).

## 8. Staged fallbacks

- **F1 (transport walls):** if §5c's `eqn_germ_eq` transport resists one honest
  session, land commit 2 WITHOUT the unconditional kit: `mkOfWitness` +
  `BaseChangeWitness`-style surjective path re-derived through `mkOfWitness` (strong ⟹
  weak) keeps (a)'s capability intact; the unconditional `mapAlg` trails as its own
  S–M lane. (b)'s flip and its transport are separable — nothing downstream regresses.
- **F2 (the flip itself walls):** revert the atomic commit 2 (commit 1 is harmless and
  stays), report, and fund (c) with the recorded statement: *refinement invariance of
  the certified class* — for adaptations `A` of the SAME `LocalEquations` where `A''`
  subdivides `A`'s pieces by basic opens, `W(A) ≃ₗ[R] W(A'')` + all four certificate
  clauses transport; plus the qc subdivision of the base-changed data into pulled
  members. Hazards recorded in §4 (refined-colength finiteness = support-tube grade;
  defeq discipline loss). Fund only on F2 — never as a parallel hedge.
- **Orchestrator note:** if BOTH fail, the vehicle/DDR-9/Task-7 rows of §2 are blocked
  at the design level and DAT-D needs a re-derivation from the worksheet — that outcome
  is not visible from any evidence gathered this pass (the probe and the landed
  mechanisms say F1/F2 are remote).

## 9. Discipline

spec-dd-1 §5 verbatim (local-instance header is part of every statement's meaning;
in-file `maxSynthPendingDepth 3` where the touched files already pin it; ≤ 500 lines;
`backward.isDefEq.respectTransparency false` only where already present). Additions,
binding on the migration lane: (1) commit 1 MUST coin `eqn_germ_eq` with the §5a
signature byte-compatible with the future field projection; (2) commit 2 is ONE commit
— never leave the tree between field-swap and MapAlg rewrite; (3) `rfl`-bridge hazards
of I-0194 apply unchanged (the pulled apparatus stays defeq — do not "improve" it);
(4) no witness-shaped hypotheses may be reintroduced downstream (a consumer needing a
global member per piece has left the design — escalate, don't add fields).

*End of spec. The §1 verdict, §5 spellings, §6 migration map, and §7 window are the
deliverables of record for the DD-1 pt-transport seam adjudication.*
